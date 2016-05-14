/*******************************************************************************/
/*  Copyright (C) 1994 - 2007, Performance Dynamics Company                    */
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

/*
 * testmsq.c
 * 
 * test multiserver queue (MSQ) code.
 * 
 * Created by NJG on Mon, Apr 2, 2007
 *
 *  $Id$
 */

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "PDQ_Lib.h"

int main(void) {

	int              nodes;
	int              streams;
	
	double           arate   = 75.0;
	double           stime   = 0.20;
	int              servers = 30;
	char       		 name[10];       // name buffer
	
	name[0] = '\0';
	sprintf(name, "mServer%d", servers);   
	
	PDQ_Init("MSQ Test");
	
	nodes = PDQ_CreateNode(name, servers, MSQ); // multiserver node
	streams = PDQ_CreateOpen("Work", arate);
	PDQ_SetDemand(name, "Work", stime);
	
	PDQ_Solve(CANON);
	PDQ_Report();
   
}  // main


