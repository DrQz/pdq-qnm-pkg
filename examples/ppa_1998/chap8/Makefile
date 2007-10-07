#
#  $Id$
#
#--------------------------------------------------------------------------

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

baseline:
	${CC} -o baseline baseline.c -I$(INCL) -L$(LIB) -lpdq -lm

scaleup:
	${CC} -o scaleup scaleup.c -I$(INCL) -L$(LIB) -lpdq -lm

upgrade1:
	${CC} -o upgrade1 upgrade1.c -I$(INCL) -L$(LIB) -lpdq -lm

upgrade2:
	${CC} -o upgrade2 upgrade2.c -I$(INCL) -L$(LIB) -lpdq -lm

#--------------------------------------------------------------------------

ln:
	ln ../../../java/examples/Ch8_*.out .

clean:
	-/bin/rm ${PGM} *.o *.exe *.log *~ *.tst

#--------------------------------------------------------------------------

test:
	./test.sh

#--------------------------------------------------------------------------

