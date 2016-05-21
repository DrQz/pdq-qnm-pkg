#  $Id$
#
#---------------------------------------------------------------------
EXAMPLES := $(wildcard examples/ppa_1998/chap*)
ECHO := /bin/echo
ECHO_OPTION := -e
ECHO_MESSAGE := "\n\nMaking chapter $@ PDQ files ...\n"
.PHONY: all lib perl5 python R examples $(EXAMPLES)


PDQ_VERSION=$(shell tools/getversion)
DISTRIB_BUILD_TMP := /tmp/pdq-dists
DISTRIB_FULL := $(DISTRIB_BUILD_TMP)/FULL
DISTRIB_R := $(DISTRIB_BUILD_TMP)/R
DISTRIB_PYTHON := $(DISTRIB_BUILD_TMP)/python
DISTRIB_PERL5 := $(DISTRIB_BUILD_TMP)/perl5


all:	lib perl5 R python examples

lib:
	make --directory=$@

perl5:
	make --directory=$@ -f ./setup.mk

python:
	make --directory=$@

R:
	make --directory=$@

examples: $(EXAMPLES)

$(EXAMPLES):
	@$(ECHO) $(ECHO_OPTION) $(ECHO_MESSAGE)
	$(MAKE) --directory=$@ -f Makefile all

#---------------------------------------------------------------------

swig:
	make --directory=perl5 -f setup.mk swig
	make --directory=python swig
	make --directory=R swig

#---------------------------------------------------------------------

test:
	make --directory=examples test

#---------------------------------------------------------------------

clean:
	-/bin/rm *~ 
	make --directory=lib clean
	make --directory=perl5 -f setup.mk clean
	make --directory=python clean
	make --directory=R clean
	make --directory=examples clean

#---------------------------------------------------------------------

dist: swig
	@echo $(PDQ_VERSION)
	-rm -rf $(DISTRIB_BUILD_TMP)
	-mkdir -p $(DISTRIB_FULL)/pdq
	-tar -cf - --exclude=.git . | (cd $(DISTRIB__FULL)/pdq; tar -xf - )
#	-(cd /tmp/pdq; rm headache.cfg header.txt)
	-(cd $(DISTRIB_FULL); tar cvf pdq.tar pdq; gzip pdq.tar)
	-rm -rf $(DISTRIB_FULL)/pdq
	-mv $(DISTRIB_FULL)/pdq.tar.gz $(DISTRIB_FULL)/PDQ-$(PDQ_VERSION).tar.gz
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
