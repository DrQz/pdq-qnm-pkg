#  $Id$
#
#---------------------------------------------------------------------
ECHO := /bin/echo
ECHO_OPTION := -e
ECHO_MESSAGE := "\n\nMaking chapter $@ PDQ files ...\n"
.PHONY: all lib perl5 python R 


PDQ_VERSION=$(shell tools/getversion)
DISTRIB_BUILD_TMP := /tmp/pdq-dists
DISTRIB_FULL := $(DISTRIB_BUILD_TMP)/FULL
DISTRIB_R := $(DISTRIB_BUILD_TMP)/R
DISTRIB_PYTHON := $(DISTRIB_BUILD_TMP)/python
DISTRIB_PERL5 := $(DISTRIB_BUILD_TMP)/perl5


all:	lib perl5 R python 

lib:
	make --directory=$@

perl5:
	make --directory=interfaces $@ 

python:
	make --directory=interfaces $@

R:
	make --directory=interfaces $@


$(EXAMPLES):
	@$(ECHO) $(ECHO_OPTION) $(ECHO_MESSAGE)
	$(MAKE) --directory=$@ -f Makefile all

#---------------------------------------------------------------------


clean:
	-/bin/rm -f *~ 
	make --directory=lib clean
	make --directory=interfaces clean

#---------------------------------------------------------------------

dist: 
	@echo $(PDQ_VERSION)
	-rm -rf $(DISTRIB_BUILD_TMP)
	-mkdir -p $(DISTRIB_FULL)/pdq
	-export DISTRIB_FULL=$(DISTRIB_FULL) ; tar -cf - --exclude=.git . | (cd ${DISTRIB_FULL}/pdq; tar -xf - )
#	-(cd /tmp/pdq; rm headache.cfg header.txt)
	-(cd $(DISTRIB_FULL); tar cvf pdq.tar pdq; gzip pdq.tar)
	-rm -rf $(DISTRIB_FULL)/pdq
	-mv $(DISTRIB_FULL)/pdq.tar.gz $(DISTRIB_FULL)/PDQ-$(PDQ_VERSION).tar.gz
	-make --directory=interfaces dist
	make clean

#---------------------------------------------------------------------
