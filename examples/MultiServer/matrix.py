#!/usr/bin/env python
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

