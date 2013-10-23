/*
  Author: Pontus Östlund <https://profiles.google.com/poppanator>

  Permission to copy, modify, and distribute this source for any legal
  purpose granted as long as my name is still attached to it. More
  specifically, the GPL, LGPL and MPL licenses apply to this software.
*/

inherit Social.Api : parent;

//! The base uri to the Graph API
constant API_URI = "https://graph.facebook.com";

//! Getter for the @[Any] object which is a generic object for making request
//! to the Facebook Graph API
//!
//! @seealso
//!  @[Any]
Any `any()
{
  return _any || (_any = Any());
}

//! Make a generic @expr{GET@} request to the Facebook Graph API.
//!
//! @param path
//!  What to request. Like @expr{me@}, @expr{me/pictures@},
//!  @expr{[some_id]/something@}.
//!
//! @param params
//! @param cb
//!  Callback for async requests
mapping get(string path, void|ParamsArg params, void|Callback cb)
{
  return `any()->get(path, params, cb);
}

//! Make a generic @expr{PUT@} request to the Facebook Graph API.
//!
//! @param path
//!  What to request. Like @expr{me@}, @expr{me/pictures@},
//!  @expr{[some_id]/something@}.
//!
//! @param params
//! @param cb
//!  Callback for async requests
mapping put(string path, void|ParamsArg params, void|Callback cb)
{
  return `any()->put(path, params, cb);
}

//! Make a generic @expr{POST@} request to the Facebook Graph API.
//!
//! @param path
//!  What to request. Like @expr{me@}, @expr{me/pictures@},
//!  @expr{[some_id]/something@}.
//!
//! @param params
//! @param data
//! @param cb
//!  Callback for async requests
mapping post(string path, void|ParamsArg params, void|string data,
             void|Callback cb)
{
  return `any()->post(path, params, cb);
}

//! Make a generic @expr{DELETE@} request to the Facebook Graph API.
//!
//! @param path
//!  What to request. Like @expr{me@}, @expr{me/pictures@},
//!  @expr{[some_id]/something@}.
//!
//! @param params
//! @param cb
//!  Callback for async requests
mapping delete(string path, void|ParamsArg params, void|Callback cb)
{
  return `any()->delete(path, params, cb);
}

//! Default parameters that goes with every call
protected mapping default_params()
{
  return ([ "format" : "json" ]);
}

// Just a convenience class
protected class Method
{
  inherit Social.Api.Method;

  //! Internal convenience method
  public mixed get(string s, void|ParamsArg p, void|Callback cb)
  {
    return parent::get(get_uri(METHOD_PATH + s), p, cb);
  }

  //! Internal convenience method
  public mixed put(string s, void|ParamsArg p, void|Callback cb)
  {
    return parent::put(get_uri(METHOD_PATH + s), p, cb);
  }

  //! Internal convenience method
  public mixed post(string s, void|ParamsArg p, void|Callback cb)
  {
    return parent::post(get_uri(METHOD_PATH + s), p, 0, cb);
  }

  //! Internal convenience method
  public mixed delete(string s, void|ParamsArg p, void|Callback cb)
  {
    return parent::delete(get_uri(METHOD_PATH + s), p, cb);
  }
}

//! A generic wrapper around @[Method]
protected class Any
{
  inherit Method;
  protected constant METHOD_PATH = "/";
}

private Any _any;

//! Authorization class.
//!
//! @seealso
//!  @[Social.Api.Authorization]
class Authorization
{
  inherit Social.Api.Authorization;

  enum Scopes {
    // User scopes
    SCOPE_EMAIL = "email",
    SCOPE_PUBLISH_ACTIONS = "publish_actions",
    SCOPE_ABOUT_ME = "user_about_me",
    SCOPE_ACTIONS_BOOKS = "user_actions.books",
    SCOPE_ACTIONS_MUSIC = "user_actions.music",
    SCOPE_ACTIONS_NEWS = "user_actions.news",
    SCOPE_ACTIONS_VIDEO = "user_actions.video",
    SCOPE_ACTIVITIES = "user_activities",
    SCOPE_BIRTHDAY = "user_birthday",
    SCOPE_EDUCATION_HISTORY = "user_education_history",
    SCOPE_EVENTS = "user_events",
    SCOPE_FRIENDS = "user_friends",
    SCOPE_GAMES_ACTIVITY = "user_games_activity",
    SCOPE_GROUPS = "user_groups",
    SCOPE_HOMETOWN = "user_hometown",
    SCOPE_INTERESTS = "user_interests",
    SCOPE_LIKES = "user_likes",
    SCOPE_LOCATION = "user_location",
    SCOPE_NOTES = "user_notes",
    SCOPE_PHOTOS = "user_photos",
    SCOPE_QUESTIONS = "user_questions",
    SCOPE_RELATIONSHIP_DETAILS = "user_relationship_details",
    SCOPE_RELATIONSHIPS = "user_relationships",
    SCOPE_RELIGION_POLITICS = "user_religion_politics",
    SCOPE_STATUS = "user_status",
    SCOPE_SUBSCRIPTIONS = "user_subscriptions",
    SCOPE_VIDEOS = "user_videos",
    SCOPE_WEBSITE = "user_website",
    SCOPE_WORK_HISTORY = "user_work_history",

    // Friends scope
    SCOPE_FRIENDS_ABOUT_ME = "friends_about_me",
    SCOPE_FRIENDS_ACTIONS_BOOKS = "friends_actions.books",
    SCOPE_FRIENDS_ACTIONS_MUSIC = "friends_actions.music",
    SCOPE_FRIENDS_ACTIONS_NEWS = "friends_actions.news",
    SCOPE_FRIENDS_ACTIONS_VIDEO = "friends_actions.video",
    SCOPE_FRIENDS_ACTIVITIES = "friends_activities",
    SCOPE_FRIENDS_BIRTHDAY = "friends_birthday",
    SCOPE_FRIENDS_EDUCATION_HISTORY = "friends_education_history",
    SCOPE_FRIENDS_EVENTS = "friends_events",
    SCOPE_FRIENDS_GAMES_ACTIVITY = "friends_games_activity",
    SCOPE_FRIENDS_GROUPS = "friends_groups",
    SCOPE_FRIENDS_HOMETOWN = "friends_hometown",
    SCOPE_FRIENDS_INTERESTS = "friends_interests",
    SCOPE_FRIENDS_LIKES = "friends_likes",
    SCOPE_FRIENDS_LOCATION = "friends_location",
    SCOPE_FRIENDS_NOTES = "friends_notes",
    SCOPE_FRIENDS_PHOTOS = "friends_photos",
    SCOPE_FRIENDS_QUESTIONS = "friends_questions",
    SCOPE_FRIENDS_RELATIONSHIP_DETAILS = "friends_relationship_details",
    SCOPE_FRIENDS_RELATIONSHIPS = "friends_relationships",
    SCOPE_FRIENDS_RELIGION_POLITICS = "friends_religion_politics",
    SCOPE_FRIENDS_STATUS = "friends_status",
    SCOPE_FRIENDS_SUBSCRIPTIONS = "friends_subscriptions",
    SCOPE_FRIENDS_VIDEOS = "friends_videos",
    SCOPE_FRIENDS_WEBSITE = "friends_website",
    SCOPE_FRIENDS_WORK_HISTORY = "friends_work_history",

    // Extended permission
    SCOPE_ADS_MANAGEMENT = "ads_management",
    SCOPE_ADS_READ = "ads_read",
    SCOPE_CREATE_EVENT = "create_event",
    SCOPE_CREATE_NOTE = "create_note",
    SCOPE_EXPORT_STREAM = "export_stream",
    SCOPE_FRIENDS_ONLINE_PRESENCE = "friends_online_presence",
    SCOPE_MANAGE_FRIENDLISTS = "manage_friendlists",
    SCOPE_MANAGE_NOTIFICATIONS = "manage_notifications",
    SCOPE_MANAGE_PAGES = "manage_pages",
    SCOPE_PHOTO_UPLOAD = "photo_upload",
    SCOPE_PUBLISH_STREAM = "publish_stream",
    SCOPE_READ_FRIENDLISTS = "read_friendlists",
    SCOPE_READ_INSIGHTS = "read_insights",
    SCOPE_READ_MAILBOX = "read_mailbox",
    SCOPE_READ_PAGE_MAILBOXES = "read_page_mailboxes",
    SCOPE_READ_REQUESTS = "read_requests",
    SCOPE_READ_STREAM = "read_stream",
    SCOPE_RSVP_EVENT = "rsvp_event",
    SCOPE_SHARE_ITEM = "share_item",
    SCOPE_SMS = "sms",
    SCOPE_STATUS_UPDATE = "status_update",
    SCOPE_USER_ONLINE_PRESENCE = "user_online_presence",
    SCOPE_VIDEO_UPLOAD = "video_upload",
    SCOPE_XMPP_LOGIN = "xmpp_login"
  };

  constant OAUTH_AUTH_URI  = API_URI + "/oauth/authorize";
  constant OAUTH_TOKEN_URI = API_URI + "/oauth/access_token";

  protected multiset valid_scopes = (<
    SCOPE_EMAIL,SCOPE_PUBLISH_ACTIONS,SCOPE_ABOUT_ME,SCOPE_ACTIONS_BOOKS,
    SCOPE_ACTIONS_MUSIC,SCOPE_ACTIONS_NEWS,SCOPE_ACTIONS_VIDEO,SCOPE_ACTIVITIES,
    SCOPE_BIRTHDAY,SCOPE_EDUCATION_HISTORY,SCOPE_EVENTS,SCOPE_FRIENDS,
    SCOPE_GAMES_ACTIVITY,SCOPE_GROUPS,SCOPE_HOMETOWN,SCOPE_INTERESTS,
    SCOPE_LIKES,SCOPE_LOCATION,SCOPE_NOTES,SCOPE_PHOTOS,SCOPE_QUESTIONS,
    SCOPE_RELATIONSHIP_DETAILS,SCOPE_RELATIONSHIPS,SCOPE_RELIGION_POLITICS,
    SCOPE_STATUS,SCOPE_SUBSCRIPTIONS,SCOPE_VIDEOS,SCOPE_WEBSITE,
    SCOPE_WORK_HISTORY,SCOPE_FRIENDS_ABOUT_ME,SCOPE_FRIENDS_ACTIONS_BOOKS,
    SCOPE_FRIENDS_ACTIONS_MUSIC,SCOPE_FRIENDS_ACTIONS_NEWS,
    SCOPE_FRIENDS_ACTIONS_VIDEO,SCOPE_FRIENDS_ACTIVITIES,SCOPE_FRIENDS_BIRTHDAY,
    SCOPE_FRIENDS_EDUCATION_HISTORY,SCOPE_FRIENDS_EVENTS,
    SCOPE_FRIENDS_GAMES_ACTIVITY,SCOPE_FRIENDS_GROUPS,SCOPE_FRIENDS_HOMETOWN,
    SCOPE_FRIENDS_INTERESTS,SCOPE_FRIENDS_LIKES,SCOPE_FRIENDS_LOCATION,
    SCOPE_FRIENDS_NOTES,SCOPE_FRIENDS_PHOTOS,SCOPE_FRIENDS_QUESTIONS,
    SCOPE_FRIENDS_RELATIONSHIP_DETAILS,SCOPE_FRIENDS_RELATIONSHIPS,
    SCOPE_FRIENDS_RELIGION_POLITICS,SCOPE_FRIENDS_STATUS,
    SCOPE_FRIENDS_SUBSCRIPTIONS,SCOPE_FRIENDS_VIDEOS,SCOPE_FRIENDS_WEBSITE,
    SCOPE_FRIENDS_WORK_HISTORY,SCOPE_ADS_MANAGEMENT,SCOPE_ADS_READ,
    SCOPE_CREATE_EVENT,SCOPE_CREATE_NOTE,SCOPE_EXPORT_STREAM,
    SCOPE_FRIENDS_ONLINE_PRESENCE,SCOPE_MANAGE_FRIENDLISTS,
    SCOPE_MANAGE_NOTIFICATIONS,SCOPE_MANAGE_PAGES,SCOPE_PHOTO_UPLOAD,
    SCOPE_PUBLISH_STREAM,SCOPE_READ_FRIENDLISTS,SCOPE_READ_INSIGHTS,
    SCOPE_READ_MAILBOX,SCOPE_READ_PAGE_MAILBOXES,SCOPE_READ_REQUESTS,
    SCOPE_READ_STREAM,SCOPE_RSVP_EVENT,SCOPE_SHARE_ITEM,SCOPE_SMS,
    SCOPE_STATUS_UPDATE,SCOPE_USER_ONLINE_PRESENCE,SCOPE_VIDEO_UPLOAD,
    SCOPE_XMPP_LOGIN >);
}
