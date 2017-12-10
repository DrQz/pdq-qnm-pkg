###########################################################################
#  Copyright (C) 1994 - 2018, Performance Dynamics Company
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

# Updated by NJG on Sun Dec 10 13:55:00 2017
# $Id: httpd.R,v 1.3 2013/02/13 03:04:58 pjpuglia Exp $

library(pdq)

# See PPDQ book http://www.perfdynamics.com/books.html
# Section 12.2.2 HTTP Analysis Using PDQ
# and Listing 12.3 httpd.pl

clients <- 5
smaster <- 0.0109 #seconds
sdemon  <- 0.0044 #seconds
work    <- "homepage"
slaves  <- c()
nslaves <- 16
sapply(1:nslaves, function(x) {slaves[x] <<- paste("slave", x, sep="")})

pdq::Init("HTTPd Prefork")

pdq::CreateClosed(work, TERM, clients, 0.0)
pdq::CreateNode("master", CEN, FCFS)
pdq::SetDemand("master", work, smaster)

for(sname in slaves) {
  pdq::CreateNode(sname, CEN, FCFS)
  pdq::SetDemand(sname, work, sdemon / nslaves)
}

pdq::Solve(EXACT)
pdq::Report()
