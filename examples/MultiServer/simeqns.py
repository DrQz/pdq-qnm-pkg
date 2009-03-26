#!/usr/bin/env python
###############################################################################
#  Copyright (C) 1994 - 2007, Performance Dynamics Company                    #
#                                                                             #
#  This software is licensed as described in the file COPYING, which          #
#  you should have received as part of this distribution. The terms           #
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.    #
#                                                                             #
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell   #
#  copies of the Software, and permit persons to whom the Software is         #
#  furnished to do so, under the terms of the COPYING file.                   #
#                                                                             #
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  #
#  KIND, either express or implied.                                           #
###############################################################################

#
# simeqns.py
#
# Created by NJG on Thu, Apr 19, 2007


from numpy import *
from numpy.linalg import solve


# From http://www.scipy.org/Numpy_Example_List
# solve()
# The system of equations we want to solve for (x0,x1,x2):
#  3 x0 + 1 x1 + 5 x2 = 6
#  1 x0 +        8 x2 = 7
#  2 x0 + 1 x1 + 4 x2 = 8

a = array([[3,1,5],[1,0,8],[2,1,4]])
b = array([6,7,8])
x = solve(a,b)
print x             # The solution
print dot(a,x)      # Check if get RHS
