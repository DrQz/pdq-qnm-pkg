##/*******************************************************************************/
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
#
#/*
# * triple_msq.c
# * 
# * Test case for 3 M/M/m queues in tandem
# *
# * Created by NJG on Mon, Apr 2, 2007
# *
# *
# */
 




   arrivalRate  	<- 75.0
   servTime1 		<- 0.100
   servTime2 		<- 0.200
   nthreadsA 		<- 15
   nthreadsB 		<- 30
   nthreadsC 		<- 15

   Init("Triple MSQ Test")
   
   CreateNode("mServerA", nthreadsA, MSQ)
   CreateNode("mServerB", nthreadsB, MSQ)
   CreateNode("mServerC", nthreadsC, MSQ)

   CreateOpen("Workflow", arrivalRate)

   SetDemand("mServerA", "Workflow", servTime1)
   SetDemand("mServerB", "Workflow", servTime2)
   SetDemand("mServerC", "Workflow", servTime1)

   Solve(CANON)
   Report()
