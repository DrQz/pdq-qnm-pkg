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

# Updated by NJG on Sun Dec 10 11:49:32 2017
# $Id: ebiz.R,v 1.3 2013/02/13 03:04:58 pjpuglia Exp $

library(pdq)

# PDQ model of a 3-tier business application.
# See PPDQ book http://www.perfdynamics.com/books.html
# Section 12.4.4 Preliminary PDQ Model

model <- "3-tier Middleware Model"
work  <- "eBiz-tx"
node1 <- "WebServer"
node2 <- "AppServer"
node3 <- "DBMServer"
think <-  0.0 * 1e-3  # Pro-tip: treat Z as a free param

# Add dummy node names here
node4 <- "DummySvr"
users <- 10

pdq::Init(model)

pdq::CreateClosed(work, TERM, users, think)

pdq::CreateNode(node1, CEN, FCFS)
pdq::CreateNode(node2, CEN, FCFS)
pdq::CreateNode(node3, CEN, FCFS)
pdq::CreateNode(node4, CEN, FCFS)

#  NOTE: timebase is seconds
pdq::SetDemand(node1, work, 9.8 * 1e-3)
pdq::SetDemand(node2, work, 2.5 * 1e-3)
pdq::SetDemand(node3, work, 0.72 * 1e-3)

#  dummy (network) service demand
pdq::SetDemand(node4, work, 9.8 * 1e-3)

pdq::Solve(EXACT)
pdq::Report()


