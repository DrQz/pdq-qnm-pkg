#!/usr/bin/env python
"""
    bookstore.py
    
    Created by NJG on Fri, Apr 13, 2007
    
    PDQ model using 2 MSQ nodes in tandem.
"""

import pdq

from math import *

arrivalRate     = 40.0/60   # cust per min
browseTime      = 45.0      # mins 
buyingTime      = 4.0       # mins
cashiers        = 3
    
pdq.Init("Big Book Store Model")
    
# Create an open circuit Jackson network
streams = pdq.CreateOpen("Customers", arrivalRate)

pdq.SetWUnit("Cust")
pdq.SetTUnit("Min")     # timebase for PDQ report

#*** New MSQ flag tells PDQ the following are multiserver nodes ***

# M/M/inf queue defined as 100 times the number of Erlangs = lambda * S
nodes = pdq.CreateNode("Browsing", int(ceil(arrivalRate * browseTime)) * 100, pdq.MSQ) 

# M/M/m where m is the number of cashiers   
nodes = pdq.CreateNode("Checkout", cashiers, pdq.MSQ) 

# Set service times ...
pdq.SetDemand("Browsing", "Customers", browseTime)
pdq.SetDemand("Checkout", "Customers", buyingTime)

pdq.Solve(pdq.CANON)
pdq.Report()
