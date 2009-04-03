#
#  $Id$
#
#--------------------------------------------------------------------------

CC     = gcc
EXT    = .exe
LIB    = ../../../lib
INCL   = ../../../lib

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

ebiz:	ebiz.c
	${CC} -o ebiz ebiz.c -I $(INCL) -L$(LIB) -lpdq -lm

http:	http.c
	${CC} -o http http.c -I $(INCL) -L$(LIB) -lpdq -lm

iis:	iis.c
	${CC} -o iis iis.c -I $(INCL) -L$(LIB) -lpdq -lm

#--------------------------------------------------------------------------

ln:
	ln ../../../java/examples/Ch9_*.out .

diff:
	diff ebiz.out Ch9_eBiz.out
	diff http.out Ch9_HTTP.out
	diff iis.out Ch9_IIS.out

clean:
	-/bin/rm *.o *.exe ${PGM} *~ *.log *.tst Ch9_*.out

#--------------------------------------------------------------------------

test:
	./test.sh

#--------------------------------------------------------------------------

