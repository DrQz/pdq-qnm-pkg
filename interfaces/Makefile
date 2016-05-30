#  $Id$
#
#---------------------------------------------------------------------
EXAMPLES := $(wildcard examples/ppa_1998/chap*)
ECHO := /bin/echo
ECHO_OPTION := -e
ECHO_MESSAGE := "\n\nMaking chapter $@ PDQ files ...\n"
.PHONY: all lib perl5 python R examples $(EXAMPLES)


PDQ_VERSION=$(shell cd .. ; tools/getversion)
DISTRIB_BUILD_TMP := /tmp/pdq-dists
DISTRIB_FULL := $(DISTRIB_BUILD_TMP)/FULL
DISTRIB_R := $(DISTRIB_BUILD_TMP)/R
DISTRIB_PYTHON := $(DISTRIB_BUILD_TMP)/python
DISTRIB_PERL5 := $(DISTRIB_BUILD_TMP)/perl5


all:	perl5 R python 


perl5:
	make --directory=$@ -f ./setup.mk

python:
	make --directory=$@

R:
	make --directory=$@


#---------------------------------------------------------------------

swig:
	make --directory=perl5 -f setup.mk swig
	make --directory=python swig

#---------------------------------------------------------------------

test:
	make --directory=examples test

#---------------------------------------------------------------------

clean:
	-/bin/rm -f *~ 
	make --directory=perl5 -f setup.mk clean
	make --directory=python clean
	make --directory=R clean

#---------------------------------------------------------------------

dist: swig
	@echo $(PDQ_VERSION)
	make --directory=R dist	
	-mkdir -p $(DISTRIB_R)
	-cp R/*.tar.gz $(DISTRIB_R)/
	make --directory=perl5 -f setup.mk dist
	-mkdir -p $(DISTRIB_PERL5)
	-cp perl5/*.tar.gz $(DISTRIB_PERL5)/
	make --directory=python dist
	-mkdir -p $(DISTRIB_PYTHON)
	-cp python/dist/*.tar.gz $(DISTRIB_PYTHON)/
	make clean

#---------------------------------------------------------------------
