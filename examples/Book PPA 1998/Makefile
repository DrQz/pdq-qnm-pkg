# This is the top-level make file for all the PDQ models in directories 
# that correspond to the chapters in the book "The Practical Performance Analyst:  
# Performance-By-Design Techniques for Distributed Systems" (McGraw-Hill 1998)
# Second Printing (iUniverse 2000)
# See http://www.perfdynamics.com/iBook/ppa.html for more details.
# 
#  $Id$
#
#---------------------------------------------------------------------
.PHONY: all test

all:
	-(cd chap2; make)
	-(cd chap3; make)
	-(cd chap6; make)
	-(cd chap8; make)
	-(cd chap9; make)

#---------------------------------------------------------------------

test:
	make --directory=chap2 test
#	-(cd chap2;make test)
	make --directory=chap3 test
	make --directory=chap6 test
	make --directory=chap8 test
	make --directory=chap9 test

#---------------------------------------------------------------------


clean:
	-(cd chap2; make clean)
	-(cd chap3; make clean)
	-(cd chap6; make clean)
	-(cd chap7; make clean)
	-(cd chap8; make clean)
	-(cd chap9; make clean)

#---------------------------------------------------------------------

