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

# Updated by NJG on Sun Dec 10 12:59:10 2017
# $Id: passport2.R,v 1.2 2012/11/13 07:40:24 earl-lang Exp $

# This model is a Jackson network with feedback.
# See PPDQ book http://www.perfdynamics.com/books.html
# Section 5.5.4 Parallel Queues in Series
# and Listing 5.1. Passport renewal model

arrivals <- 15 / 3600 

# Branching probabilities appear in SetDemand times. 
p12 <- 0.30
p13 <- 0.70
p23 <- 0.20
p32 <- 0.10

# Visit ratios
v3 <- (p13 + p23 * p12) / (1 - p23 * p32)
v2 <- p12 + p32 * v3

# Initialize and solve the model 
pdq::Init("Passport Office")

pdq::CreateOpen("Applicant", arrivals)

pdq::CreateNode("Window1", CEN, FCFS)
pdq::CreateNode("Window2", CEN, FCFS)
pdq::CreateNode("Window3", CEN, FCFS)
pdq::CreateNode("Window4", CEN, FCFS)

pdq::SetDemand("Window1", "Applicant", 20.0)
pdq::SetDemand("Window2", "Applicant", 600.0 * v2)
pdq::SetDemand("Window3", "Applicant", 300.0 * v3)
pdq::SetDemand("Window4", "Applicant", 60.0)

pdq::Solve(CANON)
pdq::Report()


