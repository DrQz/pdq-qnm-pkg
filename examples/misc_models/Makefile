#
#  $Id$
#
#-----------------------------------------------------------
# Created by NJG on Thursday, May 19, 2016
# Cleaned up for PDQ 7 release


.PHONY: all test clean

CC       = gcc
EXT      = .exe
LIB      = ../../../lib
INCL     = ../../../lib

CFLAGS    = -I $(INCL) -l $(LIB) -ggdb

PGM      = \
         bookstore \
         gross_pdq42 \
         passport2

#-----------------------------------------------------------

all: ${PGM}

#-----------------------------------------------------------

bookstore: bookstore.c bookstore.o
	${CC} -o bookstore bookstore.c -I$(INCL) -L$(LIB) -lpdq -lm

gross_pdq42: gross_pdq42.c gross_pdq42.o
	${CC} -o gross_pdq42 gross_pdq42.c -I$(INCL) -L$(LIB) -lpdq -lm

passport2: passport2.c passport2.o
	${CC} -o passport2 passport2.c -I$(INCL) -L$(LIB) -lpdq -lm

#-----------------------------------------------------------

clean:
	-/bin/rm -f ${PGM} *.o *.exe *~ *.log *.tst *.out

#-----------------------------------------------------------

