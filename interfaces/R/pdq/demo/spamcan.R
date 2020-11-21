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

# Updated by NJG on Sun Dec 10 12:55:41 2017
# Created by NJG on Wed, Apr 18, 2007
# Ported to R by PJP on Thru, Aug 8, 2012
# $Id: spamcan2.R,v 1.2 2013/02/13 03:04:58 pjpuglia Exp $

library(pdq)

# Queueing model of an email-spam analyzer system comprising a
# battery of multicore servers essentially running in batch mode.
# Each node was a 4-way multicore server.
# The performance metric of interest was the mean queue length (Q).
#
# This simple M/M/4 model was developeat AOL.com and gave results 
# that were in surprisingly good agreement with monitored queue lengths.
#
# See PPDQ book http://www.perfdynamics.com/books.html
# Section 1.6 How Long Should My Queue Be?
# and Listing 1.1. Spam farm model in PDQ

# Measured performance parameters
cpusPerServer <- 4
emailThruput  <- 0.66   # emails per hour
scannerTime   <- 6.0  # seconds per email

qt <- NULL
ut <- NULL

pdq::Init("Spam Farm Model")
pdq::CreateOpen("Email", emailThruput)
pdq::CreateMultiNode(cpusPerServer, "spamCan",  MSO, FCFS)
pdq::SetDemand("spamCan", "Email", scannerTime)
pdq::Solve(CANON)
pdq::Report()

qs <- pdq::GetQueueLength("spamCan", "Email", TRANS)
ut <- pdq::GetUtilization("spamCan", "Email", TRANS)
cat(sprintf("Stretch factor: %6.4f\n", qs / (ut * cpusPerServer)))


