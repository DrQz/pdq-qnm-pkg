/*******************************************************************************/
/*  Copyright (C) 1994 - 2009, Performance Dynamics Company                    */
/*                                                                             */
/*  This software is licensed as described in the file COPYING, which          */
/*  you should have received as part of this distribution. The terms           */
/*  are also available at http://www.perfdynamics.com/Tools/copyright.html.    */
/*                                                                             */
/*  You may opt to use, copy, modify, merge, publish, distribute and/or sell   */
/*  copies of the Software, and permit persons to whom the Software is         */
/*  furnished to do so, under the terms of the COPYING file.                   */
/*                                                                             */
/*  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  */
/*  KIND, either express or implied.                                           */
/*******************************************************************************/

//
//  $Id$
//
//-------------------------------------------------------------------------

#define g_debug(msg) \
	fprintf(stderr, "%s:%d " msg, __FILE__, __LINE__)

#define g_debugf(fmt, args...) \
	fprintf(stderr, "%s:%d " fmt, __FILE__, __LINE__, ##args)

//-------------------------------------------------------------------------

