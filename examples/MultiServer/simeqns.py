#!/usr/bin/env python
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
