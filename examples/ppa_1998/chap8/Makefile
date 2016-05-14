#
#  $Id$
#
#--------------------------------------------------------------------------
# Updated by NJG on Tuesday, August 18, 2015
# Make file was not compiling b/c now needs explicit syntax

EXT       = .exe
CC        = gcc
LIB       = ../../../lib
INCL      = ../../../lib

CFLAGS    = -I $(INCL) -l $(LIB) -ggdb

#--------------------------------------------------------------------------

PGM       = \
            baseline \
            scaleup \
            upgrade1 \
            upgrade2

#--------------------------------------------------------------------------

all: ${PGM}

#--------------------------------------------------------------------------

baseline: baseline.c baseline.o
	${CC} -o baseline baseline.c -I$(INCL) -L$(LIB) -lpdq -lm

scaleup: scaleup.c scaleup.o
	${CC} -o scaleup scaleup.c -I$(INCL) -L$(LIB) -lpdq -lm

upgrade1: upgrade1.c upgrade1.o
	${CC} -o upgrade1 upgrade1.c -I$(INCL) -L$(LIB) -lpdq -lm

upgrade2: upgrade2.c upgrade2.o
	${CC} -o upgrade2 upgrade2.c -I$(INCL) -L$(LIB) -lpdq -lm

#--------------------------------------------------------------------------

ln:
	ln ../../../java/examples/Ch8_*.out .

clean:
	-/bin/rm -f ${PGM} *.o *.exe *.log *~ *.tst

#--------------------------------------------------------------------------

test:
	./test.sh

#--------------------------------------------------------------------------

