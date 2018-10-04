#
#  $Id$
#
#--------------------------------------------------------------------------
# Updated by NJG on Tuesday, August 18, 2015
# Make file was not building b/c explicit src and obj dependencies needed


CFLAGS  = -O
EXT     = .exe
CC      = gcc
LIB     = ../../../lib
INCL    = ../../../lib

CFLAGS    = -I $(INCL) -l $(LIB) -ggdb

PGM     = \
          abcache \
          multibus

#--------------------------------------------------------------------------

all:	${PGM}

#--------------------------------------------------------------------------

abcache: abcache.c abcache.o
	${CC} -o abcache abcache.c -I $(INCL) -L$(LIB) -lpdq -lm

multibus: multibus.c multibus.o
	${CC} -o multibus multibus.c -I $(INCL) -L$(LIB) -lpdq -lm

#--------------------------------------------------------------------------

ln:
	ln ../../../java/examples/Ch7_*.out .

clean:
	-/bin/rm -f ${PGM} *.o *.exe *~ *.log *.tst *.out

#--------------------------------------------------------------------------

test:
	./test.sh

#--------------------------------------------------------------------------

