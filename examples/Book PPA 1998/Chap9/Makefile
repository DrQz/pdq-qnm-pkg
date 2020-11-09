#
#  $Id$
#
#--------------------------------------------------------------------------
# Updated by NJG on Tuesday, August 18, 2015
# Make file was not building b/c explicit src and obj dependencies needed

CC     = gcc
EXT    = .exe
LIB    = ../../../lib
INCL   = ../../../lib

CFLAGS    = -I $(INCL) -l $(LIB) -ggdb

PGM = \
      http \
      iis \
      ebiz

#--------------------------------------------------------------------------

.c.o:
	echo ${CC} -o $<.o $? -I $(INCL) -L $(LIB) -lpdq -lm

#--------------------------------------------------------------------------

all:	$(PGM)

#--------------------------------------------------------------------------

ebiz:	ebiz.c ebiz.o
	${CC} -o ebiz ebiz.c -I $(INCL) -L$(LIB) -lpdq -lm

http:	http.c http.o
	${CC} -o http http.c -I $(INCL) -L$(LIB) -lpdq -lm

iis:	iis.c iis.o
	${CC} -o iis iis.c -I $(INCL) -L$(LIB) -lpdq -lm

#--------------------------------------------------------------------------

ln:
	ln ../../../java/examples/Ch9_*.out .

diff:
	diff ebiz.out Ch9_eBiz.out
	diff http.out Ch9_HTTP.out
	diff iis.out Ch9_IIS.out

clean:
	-/bin/rm -f *.o *.exe ${PGM} *~ *.log *.tst *.out

#--------------------------------------------------------------------------

test:
	./test.sh

#--------------------------------------------------------------------------

