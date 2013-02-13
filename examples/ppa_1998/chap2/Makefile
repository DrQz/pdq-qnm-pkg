#
#  $Id$
#
#-----------------------------------------------------------
.PHONY: all test clean

CC       = gcc
EXT      = .exe
EXT      = 
LIB      = ../../../lib
INCL     = ../../../lib

PGM      = \
         erlang${EXT} \
         closed1${EXT} \
         open1${EXT}

#-----------------------------------------------------------

all:	${PGM}

#-----------------------------------------------------------

erlang${EXT}:
	${CC} -o erlang${EXT} erlang.c -lm

open1${EXT}:
	${CC} -o open1${EXT} open1.c -I$(INCL) -L$(LIB) -lpdq -lm

closed1${EXT}:
	${CC} -o closed1${EXT} closed1.c -I$(INCL) -L$(LIB) -lpdq -lm

#-----------------------------------------------------------

ln:
	ln ../../../java/examples/Ch2_*.out .

test:
	./test.sh

#-----------------------------------------------------------

clean:
	-/bin/rm -f ${PGM} *.exe *~ *.log *.tst Ch2_*.out

#-----------------------------------------------------------

