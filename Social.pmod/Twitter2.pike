/* -*- Mode: Pike; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 8 -*- */
//! @b{Twitter client class@}
//!
//! Copyright © 2009, Pontus Östlund - @url{www.poppa.se@}
//!
//! @fixme
//!  Implement an AsyncTwitter as well.
//!
//! @pre{@b{License GNU GPL version 3@}
//!
//! Twitter.pike is free software: you can redistribute it and/or modify
//! it under the terms of the GNU General Public License as published by
//! the Free Software Foundation, either version 3 of the License, or
//! (at your option) any later version.
//!
//! Twitter.pike is distributed in the hope that it will be useful,
//! but WITHOUT ANY WARRANTY; without even the implied warranty of
//! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//! GNU General Public License for more details.
//!
//! You should have received a copy of the GNU General Public License
//! along with Twitter.pike. If not, see <@url{http://www.gnu.org/licenses/@}>.
//! @}

#include "OAuth.pmod/oauth.h"

#ifdef TRACE
# undef TRACE
#endif

#ifdef TWITTER_DEBUG
# define TRACE(X...) \
  werror("%s:%d: %s", basename(__FILE__), __LINE__, sprintf(X))
#else
# define TRACE(X...)
#endif

import  Parser.XML.Tree;
import  .OAuth;

//! @[Social.OAuth.Client]
inherit Client;

// API members

protected string name              = "Twitter";
protected string request_token_url = "https://twitter.com/oauth/request_token";
protected string access_token_url  = "https://twitter.com/oauth/access_token";
protected string user_auth_url     = "http://twitter.com/oauth/authorize";

// Implementation specific members

protected string cache_path;
string url             = "http://twitter.com";
string replies_url     = "https://twitter.com/statuses/replies.xml";
string credentials_url = "https://twitter.com/account/"
                         "verify_credentials.xml";
string timeline_url    = "http://twitter.com/statuses/user_timeline.xml";

//! Session cookie
string session;

//! Creates a new @[Twitter] instance
//!
//! @param consumer
//! @param token
//! @param _cache_path
void create(Consumer consumer, Token token, void|string _cache_path)
{
  ::create(consumer, token);

  if (_cache_path) {
    cache_path = _cache_path;
    if (!Stdio.exist(cache_path))
      ARG_ERROR("cache_path", "Path given does not exist");
  }

  if (cache_path) {
    if (cache_path[-1] != '/')
      cache_path += "/";

    cache_path += lower_case(name);
    if (mixed e = catch(cache = DataCache(cache_path))) {
      werror("WARNING: Unable to create cache database! %s\n",
             describe_error(e));
    }
  }
}

//! Clear the cache
void clear_cache()
{
  delete_cache("cookie");
  delete_cache("token");
}

//! Fetches a request token
Token get_request_token()
{
  string ctoken;// = get_cache("request-token");

  if (!ctoken) {
    ctoken = call(request_token_url);
    set_cache("request-token", ctoken);
  }

  mapping res = ctoken && (mapping)query_to_params(ctoken);

  token = Token( res[TOKEN_KEY], res[TOKEN_SECRET_KEY] );
  return token;
}

//! Fetches an access token
Token get_access_token(void|string oauth_verifier)
{
  if (!token)
    error("Can't fetch access token when no request token is set!\n");

  string ctoken;// = get_cache("access-token");

  if (!ctoken) {
    Params pm;
    if (oauth_verifier)
      pm = Params(Param("oauth_verifier", oauth_verifier));

    ctoken = call(access_token_url, pm);
    set_cache("access-token", ctoken);
  }

  mapping p = (mapping)query_to_params(ctoken);
  token = Token( p[TOKEN_KEY], p[TOKEN_SECRET_KEY] );
  return token;
}

//! Returns the authorization URL
string get_auth_url()
{
  if (!token) get_request_token();
  return sprintf("%s?%s=%s", user_auth_url, TOKEN_KEY, (token&&token->key)||"");
}

//! Returns the full URL to the method @[method]
//!
//! @xml{<code lang="pike" detab="3">
//!  string enpoint = twitter->get_url("account/verify_credentials");
//!  // http://twitter.com/account/verify_credentials.xml
//! </code>@}
//!
//! @param method
string get_url(string method)
{
  if (method[0] != '/')
    method = "/" + method;

  if (!has_suffix(method, ".xml"))
    method += ".xml";

  return url + method;
}

//! Makes a request to @[url].
//!
//! @param url
//!  The Twitter method to call. A @tt{string@} or @[Standards.URI].
//! @param args
//! @param method
//!  @[OAuth.Request.GET] or @[OAuth.Request.POST]
//! @param expires
//!  Number of seconds to keep the cache.
//!  If @tt{-1@} the request will not be cached at all
string call(STRURI url, void|Params args, void|string method,
            void|int expires)
{
  string data;

  method = upper_case(method || "GET");
  string ckey = method + " " + url;
  if (args) ckey += "?" + args->get_signature();

  if (expires != -1) {
    if (data = get_cache(ckey))
      return data;
  }

  Request r = request(url, consumer, token, args, method);
  r->sign_request(Signature.HMAC_SHA1, consumer, token);

  if (!session)
    session = get_cache("cookie");

  Protocols.HTTP.Query q = r->submit(session && ([ "Cookie" : session ]));

  if (q->status != 200)
    error("Bad status, %d, from HTTP query!\n", q->status);

  if ( q->headers["set-cookie"] ) {
    session = q->headers["set-cookie"][0];
    set_cache("cookie", session, 3600);
  }

  data = q->data();
  if (data && expires != -1)
    set_cache(ckey, data, expires);

  return data;
}

//! Turns an XML response into an object
//!
//! @seealso
//!  Misc.SimpleXML
class Response
{
  inherit Misc.SimpleXML;
}

//! Data cache implementation
private class DataCache
{
  private string              path;
  private Cache.Storage.Yabu  storage_mgr;
  private Cache.Policy.Null   policy_mgr;
  private Cache.cache         cache;

  //! Creates a new instance of @[DataCache]
  //!
  //! @param _path
  //!  Where to put the Yabu files
  void create(string _path)
  {
    path        = _path;
    storage_mgr = Cache.Storage.Yabu(path);
    policy_mgr  = Cache.Policy.Null();
    cache       = Cache.cache(storage_mgr, policy_mgr);
  }

  //! Get cached item with key @[key]
  mixed get(string key)
  {
    return cache->lookup(key);
  }

  //! Set cache item
  //!
  //! @param key
  //! @param value
  //! @param maxlife
  void set(string key, mixed value, void|int maxlife)
  {
    cache->store(key, value, maxlife);
  }

  //! Delete item with key @[key] from the cache
  void delete(string key)
  {
    cache->delete(key);
  }
}