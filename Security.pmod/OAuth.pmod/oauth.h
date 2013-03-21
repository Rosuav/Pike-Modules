#ifndef _OAUTH_H
#define _OAUTH_H

#define OAUTH_DEBUG

#ifdef OAUTH_DEBUG
# define TRACE(X...) werror("#%s:%d: %s", basename(__FILE__), __LINE__, sprintf(X))
#else
# define TRACE(X...)
#endif

#define STRURI          string|Standards.URI
#define ASSURE_URI(U)   U && objectp(U) && U || U && Standards.URI(U)
#define EMPTY(STR)	(!STR || !sizeof(STR))
#define NOT_NULL(STR)	STR = STR||""
#define CLASS_NAME(OBJ) sprintf("%O", object_program(OBJ))-"("-")"
#define ARG_ERROR(ARG, MSG...) \
  error("Argument exception (%s): %s\n", (ARG), sprintf(MSG))

#if constant(Crypto.MD5)
# define MD5(S) String.string2hex(Crypto.MD5.hash((S)))
#else
# define MD5(S) Crypto.string_to_hex(Crypto.md5()->update((S))->digest())
#endif

#endif /* _OAUTH_H */
