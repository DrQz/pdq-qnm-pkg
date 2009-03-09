//
//  $Id$
//
//-------------------------------------------------------------------------

#define g_debug(msg) \
	fprintf(stderr, "%s:%d " msg, __FILE__, __LINE__)

#define g_debugf(fmt, args...) \
	fprintf(stderr, "%s:%d " fmt, __FILE__, __LINE__, ##args)

//-------------------------------------------------------------------------

