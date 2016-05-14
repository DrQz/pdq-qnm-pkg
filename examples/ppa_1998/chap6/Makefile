#
#  $Id$
#
#--------------------------------------------------------------------------
# Updated by NJG on Tuesday, August 18, 2015
# Make file was not building b/c explicit src and obj dependencies needed


EXT    = .exe
CC     = gcc
LIB    = ../../../lib
INCL   = ../../../lib

CFLAGS    = -I $(INCL) -l $(LIB) -ggdb

PGM    = \
         dbc \
         dbct

#--------------------------------------------------------------------------

all:	$(PGM)

#--------------------------------------------------------------------------

dbc:	dbc.c  dbc.o
	${CC} -o dbc dbc.c -I$(INCL) -L$(LIB) -lpdq -lm

dbct:	dbct.c dbct.o
	${CC} -o dbct dbct.c -I$(INCL) -L$(LIB) -lpdq -lm

#--------------------------------------------------------------------------

ln:
	ln ../../../java/examples/Ch6_*.out .

clean:
	-/bin/rm -f ${PGM} *.o *.exe *~ *.log *.tst Ch6_*.out

#--------------------------------------------------------------------------

test:
	./test.sh

#--------------------------------------------------------------------------

