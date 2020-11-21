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

# Updated by NJG on Sun Dec 10 13:10:21 2017
# $Id: cluster.R,v 1.2 2012/11/13 05:48:20 earl-lang Exp $

# This is a PDQ model of a parallel DSS database cluster.
# See PPDQ book http://www.perfdynamics.com/books.html
# Section 9.4.1 Parallel Query Cluster
# and Listing 9.2. Cluster model in PDQ

# Globals
think <- 10.0
users <- 800
Sfep  <- 0.10
Sbep  <- 0.60
Sdsu  <- 1.20
Nfep  <- 15
Nbep  <- 50
Ndsu  <- 100

pdq::Init("DB Query Cluster")

# Create parallel centers
for (k in seq(Nfep)) {
      name <- sprintf("FEP%d",k)
      pdq::CreateNode(name, CEN, FCFS)
}

for (k in seq(Nbep)) {
      name <- sprintf("BEP%d", k)
      pdq::CreateNode(name, CEN, FCFS)
}

for (k in seq(Ndsu)) {
      name <- sprintf("DSU%d", k)
      pdq::CreateNode(name, CEN, FCFS)
}

# Create the workload
pdq::CreateClosed("query", TERM, users, think)

# Set service demands using visits to parallel nodes
for (k in seq(Nfep)) {
      name <- sprintf("FEP%d", k)
      pdq::SetVisits(name, "query", 1 / Nfep, Sfep)
}

for (k in seq(Nbep)) {
      name <- sprintf("BEP%d", k)
      pdq::SetVisits(name, "query", 1 / Nbep, Sbep)
}

for (k in seq(Ndsu)) {
      name <- sprintf("DSU%d", k)
      pdq::SetVisits(name, "query", 1 / Ndsu, Sdsu)
}

pdq::Solve(APPROX)

# This is a big model with 165 PDQ nodes
# so we write the Report out to a file
pdq::Report()

