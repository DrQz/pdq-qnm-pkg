###########################################################################
#  Copyright (C) 1994--2021, Performance Dynamics Company
#  
#  This software is licensed as described in the file COPYING, which
#  you should have received as part of this distribution. The terms
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.
#
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell 
#  copies of the Software, and permit persons to whom the Software is
#  furnished to do so, under the terms of the COPYING file.
#
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF 
# ANY KIND, either express or implied.
###########################################################################
#
# mclass_open.R 
#
# Test multiple open workloads in PDQ 7.0
# Created by NJG on Sun Nov 22, 2020

library(pdq)

pdq::Init("Test Mclass Open")

pdq::CreateOpen("Wflow1", 0.5)
pdq::CreateOpen("Wflow2", 0.4)

pdq::CreateNode("Queue", CEN, FCFS)

pdq::SetDemand("Queue", "Wflow1", 1.0)
pdq::SetDemand("Queue", "Wflow2", 0.5)

pdq::Solve(STREAMING)
pdq::Report()
