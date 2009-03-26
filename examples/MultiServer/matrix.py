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
# matrix.py
#
# Created by NJG on Thu, Apr 19, 2007



from numpy import *

A = matrix( [[1,2,3],[11,12,13],[21,22,23]]) # Creates a matrix.
x = matrix( [[1],[2],[3]] )                  # Creates a matrix (like a column vector).
y = matrix( [[1,2,3]] )                      # Creates a matrix (like a row vector).
print A.T                                    # Transpose of A.
print A*x                                    # Matrix multiplication of A and x.
print linalg.inv(A)                          # Inverse of A.
print linalg.solve(A, matrix([[0,0,0]]))     # Solve the linear equation system.

