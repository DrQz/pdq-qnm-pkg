#
#  Created by NJG on Mon, Apr 2, 2007
#  Updated by NJG on Fri, Apr 6, 2007
#
#--------------------------------------------------------------------------

CC     = gcc
EXT    =
LIB    = ../../lib
INCL   = ../../lib

PGM    = \
         testmsq	\
         triple_msq	\
         mm1_test	\
         gross42

#--------------------------------------------------------------------------

all:	${PGM}

#--------------------------------------------------------------------------

testmsq: testmsq.c $(LIB)/libpdq.a
	${CC} -o testmsq testmsq.c -I$(INCL) -L$(LIB) -lpdq -lm


triple_msq: triple_msq.c $(LIB)/libpdq.a
	${CC} -o triple_msq triple_msq.c -I$(INCL) -L$(LIB) -lpdq -lm

mm1_test: mm1_test.c $(LIB)/libpdq.a
	${CC} -o mm1_test mm1_test.c -I$(INCL) -L$(LIB) -lpdq -lm

gross42: gross_pdq42.c $(LIB)/libpdq.a
	${CC} -o gross_pdq42 gross_pdq42.c -I$(INCL) -L$(LIB) -lpdq -lm
	
#--------------------------------------------------------------------------


clean:
	-/bin/rm ${PGM} *.o  *~ 

#--------------------------------------------------------------------------

