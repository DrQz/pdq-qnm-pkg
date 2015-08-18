#
#  $Id$
#
#-----------------------------------------------------------
# Updated by NJG on Tuesday, August 18, 2015
# Make file was not building b/c explicit src and obj dependencies needed


.PHONY: all test clean

CC       = gcc
EXT      = .exe
LIB      = ../../../lib
INCL     = ../../../lib

CFLAGS    = -I $(INCL) -l $(LIB) -ggdb


PGM      = \
         erlang \
         open1 \
         closed1

#-----------------------------------------------------------

all: ${PGM}

#-----------------------------------------------------------

erlang: erlang.c erlang.o
	${CC} -o erlang erlang.c -I$(INCL) -L$(LIB) -lpdq -lm

open1: open1.c open1.o
	${CC} -o open1 open1.c -I$(INCL) -L$(LIB) -lpdq -lm

closed1: closed1.c closed1.o
	${CC} -o closed1 closed1.c -I$(INCL) -L$(LIB) -lpdq -lm

#-----------------------------------------------------------

ln:
	ln ../../../java/examples/Ch2_*.out .

test:
	./test.sh

#-----------------------------------------------------------

clean:
	-/bin/rm -f ${PGM} *.o *.exe *~ *.log *.tst Ch2_*.out

#-----------------------------------------------------------

