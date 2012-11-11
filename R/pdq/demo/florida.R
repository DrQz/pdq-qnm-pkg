###############################################################################
#  Copyright (C) 1994 - 2009, Performance Dynamics Company		      #
#									      #
#  This software is licensed as described in the file COPYING, which	      #
#  you should have received as part of this distribution. The terms	      #
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.    #
#									      #
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell   #
#  copies of the Software, and permit persons to whom the Software is	      #
#  furnished to do so, under the terms of the COPYING file.		      #
#									      #
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  #
#  KIND, either express or implied.					      #
###############################################################################

#  $Id$

# From florida.pl
require(pdq)

STEP     <- 100
MAXUSERS <- 3000
think <- 10			#seconds
srvt1 <- 0.0050		#seconds
srvt2 <- 0.0035		#seconds
srvt3 <- 0.0020		#seconds
Dmax <- srvt1
Rmin <- sum(srvt1,srvt2,srvt3)

# Updated by NJG on Sunday, November 11, 2012
# Tabulate output using an R data frame.
df <- data.frame()

# iterate up to $MAXUSERS ...
# Updated by NJG on Saturday, November 110, 2012
# CreateClosed wants a REAL not an INT via as.numeric.
for (users in as.numeric(seq(1,MAXUSERS))) {
    Init("Florida Model")
    CreateClosed("benchload", TERM, users, think)
    CreateNode("Node1", CEN, FCFS)
    CreateNode("Node2", CEN, FCFS)
    CreateNode("Node3", CEN, FCFS)
    SetDemand("Node1", "benchload", srvt1)
    SetDemand("Node2", "benchload", srvt2)
    SetDemand("Node3", "benchload", srvt3)

    Solve(APPROX)

    if ( (users == 1) || (users %% STEP == 0) ) {
    	# Combine PDQ metrics into a column vector
		metrics <- c( 
			users,
	    	GetThruput(TERM, "benchload"),
	    	users / (Rmin + think),
	    	1 / Dmax,
	    	users,
	    	GetResponse(TERM, "benchload"),
	    	Rmin,
	    	(users * Dmax) - think
	    )
	    
	    # Add vector as a row to the data frame
		df <- rbind(df, metrics)
    }
}

# Add column names and display the data frame
names(df) <- c("N", "X", "Xlin", "Xmax", "N", "R", "Rmin", "Rinf")
print(df)

# Now try plotting from the data frame... Easy!
#> plot(df)
#> plot(df$N,df$X,type="b")
#> plot(df$N,df$R,type="b")
