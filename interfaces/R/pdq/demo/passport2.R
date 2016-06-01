#******************************************************************************/
#*  Copyright (C) 1994 - 2013, Performance Dynamics Company                   */
#*                                                                            */
#*  This software is licensed as described in the file COPYING, which         */
#*  you should have received as part of this distribution. The terms          */
#*  are also available at http://www.perfdynamics.com/Tools/copyright.html.   */
#*                                                                            */
#*  You may opt to use, copy, modify, merge, publish, distribute and/or sell  */
#*  copies of the Software, and permit persons to whom the Software is        */
#*  furnished to do so, under the terms of the COPYING file.                  */
#*                                                                            */
#*  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY */
#*  KIND, either express or implied.                                          */
#******************************************************************************/

# $Id: passport2.R,v 1.2 2012/11/13 07:40:24 earl-lang Exp $

#* From passport2.c
#* Jackson network with feedback.
#* Same as model in PPA book Example 3-3 on p. 96 ff.
#* 
#* Updated by NJG on Fri, Apr 6, 2007

# 16 applications per hour
arrivals <- 15.36/3600 

#   // Branching probabilities appear in SetDemand times. 
p12 <- 0.30
p13 <- 0.70
p23 <- 0.20
p32 <- 0.10

#   // Visit ratios
v3 <- (p13 + p23 * p12) / (1 - p23 * p32)
v2 <- p12 + p32 * v3

#   // Initialize and solve the model 
Init("Passport Office")

numStreams <- CreateOpen("Applicant", arrivals)
numNodes <- CreateNode("Window1", CEN, FCFS)
numNodes <- CreateNode("Window2", CEN, FCFS)
numNodes <- CreateNode("Window3", CEN, FCFS)
numNodes <- CreateNode("Window4", CEN, FCFS)
SetDemand("Window1", "Applicant", 20.0)
SetDemand("Window2", "Applicant", 600.0 * v2)
SetDemand("Window3", "Applicant", 300.0 * v3)
SetDemand("Window4", "Applicant", 60.0)
Solve(CANON)
Report()
   
