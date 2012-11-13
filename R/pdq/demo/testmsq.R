#/*******************************************************************************/
#/*  Copyright (C) 1994 - 2007, Performance Dynamics Company                    */
#/*                                                                             */
#/*  This software is licensed as described in the file COPYING, which          */
#/*  you should have received as part of this distribution. The terms           */
#/*  are also available at http://www.perfdynamics.com/Tools/copyright.html.    */
#/*                                                                             */
#/*  You may opt to use, copy, modify, merge, publish, distribute and/or sell   */
#/*  copies of the Software, and permit persons to whom the Software is         */
#/*  furnished to do so, under the terms of the COPYING file.                   */
#/*                                                                             */
#/*  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  */
#/*  KIND, either express or implied.                                           */
#/*******************************************************************************/

#/*
# * testmsq.c
# * 
# * test multiserver queue (MSQ) code.
# * 
# * Created by NJG on Mon, Apr 2, 2007
# *
# *  $Id$
# */



	
        arate   <- 75.0
	stime   <- 0.20
        servers <- 30
	
	name <- sprintf("mServer%d", servers)   
	
	Init("MSQ Test")
	
	nodes <- CreateNode(name, servers, MSQ)
	streams <- CreateOpen("Work", arate)
	SetDemand(name, "Work", stime)
	
	Solve(CANON)
	Report()
   


