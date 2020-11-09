#
#  $Id$
#
#---------------------------------------------------------------------
# Updated by NJG on Tuesday, August 18, 2015
# Make file was not building b/c explicit src and obj dependencies needed


CC      = gcc
LIB     = ../../../lib
INCL    = ../../../lib

CFLAGS    = -I $(INCL) -l $(LIB) -ggdb

EXT     = .exe

PGM     = \
   closed \
   feedback \
   fesc \
   mc-test \
   multi_class \
   mva \
   passport \
   repair \
   shadowcpu \
   simple_series

#=====================================================================

all:	$(PGM)

#---------------------------------------------------------------------

closed:	closed.c closed.o
	${CC} -o closed closed.c  -I$(INCL) -L$(LIB) -lpdq -lm

feedback: feedback.c feedback.o
	${CC} -o feedback feedback.c   -I$(INCL) -L$(LIB) -lpdq -lm

fesc: fesc.c fesc.o
	${CC} -o fesc fesc.c   -I$(INCL) -L$(LIB) -lpdq -lm

mc-test: mc-test.c mc-test.o
	${CC} -o mc-test mc-test.c  -I$(INCL) -L$(LIB) -lpdq -lm

multi_class: multi_class.c multi_class.o
	${CC} -o multi_class multi_class.c   -I$(INCL) -L$(LIB) -lpdq -lm

mva:	mva.c mva.o
	${CC} -o mva mva.c  -lm

passport:	passport.c passport.o
	${CC} -o passport passport.c   -I$(INCL) -L$(LIB) -lpdq -lm

repair:	repair.c repair.o
	${CC} -o repair repair.c -lm 

shadowcpu:	shadowcpu.c shadowcpu.o
	${CC} -o shadowcpu shadowcpu.c  -I$(INCL) -L$(LIB) -lpdq -lm

simple_series:	simple_series.c simple_series.o
	${CC} -o simple_series simple_series.c   -I$(INCL) -L$(LIB) -lpdq -lm

#---------------------------------------------------------------------

ln:
	ln ../../../java/examples/Ch3_*.out .

test:
	./test.sh
	
#-----------------------------------------------------------

clean:
	-/bin/rm -f $(PGM) *.o *.exe *~ *.log *.tst *.out

#-----------------------------------------------------------

