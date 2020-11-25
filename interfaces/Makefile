#  $Id$
#
#---------------------------------------------------------------------
EXAMPLES := $(wildcard examples/ppa_1998/chap*)
ECHO := /bin/echo
ECHO_OPTION := -e
ECHO_MESSAGE := "\n\nMaking chapter $@ PDQ files ...\n"
.PHONY: all lib R 
PDQ_VERSION=$(shell cd .. ; tools/getversion)
DISTRIB_BUILD_TMP := /tmp/pdq-dists
DISTRIB_FULL := $(DISTRIB_BUILD_TMP)/FULL
DISTRIB_R := $(DISTRIB_BUILD_TMP)/R


all:	R 


R:
	make --directory=$@



clean:
	-/bin/rm -f *~ 
	make --directory=R clean


dist: 
	@echo $(PDQ_VERSION)
	make --directory=R dist	
	-mkdir -p $(DISTRIB_R)
	-cp R/*.tar.gz $(DISTRIB_R)/
	make clean

