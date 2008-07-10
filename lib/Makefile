#
#  $Id$
#
#-----------------------------------------------------------

OSTYPE = $(shell uname)

ifeq ($(OSTYPE),CYGWIN_NT-5.1)
OSTYPE = cygwin
endif

ifeq ($(OSTYPE),SunOS)
CC     = gcc
LIB    = libpdq.so
endif

OBJ     = \
	MVA_Approx.o \
	MVA_Canon.o \
	MVA_Solve.o \
	PDQ_Build.o \
	PDQ_Exact.o \
	PDQ_Globals.o \
	PDQ_MServer.o \
	PDQ_Report.o \
	PDQ_Utils.o

#-----------------------------------------------------------

all:	$(OBJ)
ifeq ($(OSTYPE),SunOS)
	-$(CC) -G *.o -o ${LIB} -lm
else
	-ar -rv libpdq.a $(OBJ)
endif
ifeq ($(OSTYPE),cygwin)
	-ranlib libpdq.a          # Cygwin
endif
ifeq ($(OSTYPE),Darwin)
	-ranlib -sc libpdq.a      # MacOS X
endif

#-----------------------------------------------------------

clean:
	-/bin/rm *.o libpdq.a *~

#-----------------------------------------------------------

