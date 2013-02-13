#
#  $Id$
#
#---------------------------------------------------------------------

CC      = gcc
LIB     = ../../../lib
INCL    = ../../../lib

FLAGS   = -I$(INCL) -L$(LIB) -lpdq -lm

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
   simple_series \

#=====================================================================

all:	$(PGM)

#---------------------------------------------------------------------

closed:	closed.c
	${CC} -o closed closed.c $(FLAGS)

feedback:	feedback.c
	${CC} -o feedback feedback.c $(FLAGS)

fesc:	fesc.c
	${CC} -o fesc fesc.c $(FLAGS)

mc-test:	mc-test.c
	${CC} -o mc-test mc-test.c $(FLAGS)

multi_class:	multi_class.c
	${CC} -o multi_class multi_class.c $(FLAGS)

mva:	mva.c
	${CC} -o mva mva.c -lm 

passport:	passport.c
	${CC} -o passport passport.c $(FLAGS)

repair:	repair.c
	${CC} -o repair repair.c -lm 

shadowcpu:	shadowcpu.c
	${CC} -o shadowcpu shadowcpu.c $(FLAGS)

simple_series:	simple_series.c
	${CC} -o simple_series simple_series.c $(FLAGS)

#---------------------------------------------------------------------

ln:
	ln ../../../java/examples/Ch3_*.out .

test:
	./test.sh
	
#-----------------------------------------------------------

clean:
	-/bin/rm -f $(PGM) *.o *.exe *~ *.log *.tst Ch3_*.out

#-----------------------------------------------------------

