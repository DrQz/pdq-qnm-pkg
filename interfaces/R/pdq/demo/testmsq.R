# Copyright (C) 1994 - 2018, Performance Dynamics Company  
# This software is licensed as described in the file COPYING, which 
# you should have received as part of this distribution. The terms
# are also available at http://www.perfdynamics.com/Tools/copyright.html.    
# You may opt to use, copy, modify, merge, publish, distribute and/or sell
# copies of the Software, and permit persons to whom the Software is
# furnished to do so, under the terms of the COPYING file.
# This software is distributed on an "AS IS" basis, WITHOUT WARRANTY 
# OF ANY KIND, either express or implied.                                   

# $Id: testmsq.R,v 1.3 2013/02/13 03:04:58 pjpuglia Exp $

# From testmsq.c
# test multiserver queue (MSQ) code.
# Created by NJG on Mon, Apr 2, 2007

arate   <- 75.0
stime   <- 0.20
servers <- 30

pdq::Init("Multiserver Test")
	
pdq::CreateOpen("Work", arate)
pdq::CreateMultiNode(servers, "mServer", CEN, FCFS)
pdq::SetDemand("mServer", "Work", stime)

pdq::Solve(CANON)
pdq::Report()
   


