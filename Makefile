#  $Id$
#
#---------------------------------------------------------------------
ECHO := /bin/echo
ECHO_OPTION := -e
ECHO_MESSAGE := "\n\nMaking chapter $@ PDQ files ...\n"
.PHONY: all lib R 


PDQ_VERSION=$(shell tools/getversion)
DISTRIB_BUILD_TMP := /tmp/pdq-dists
DISTRIB_FULL := $(DISTRIB_BUILD_TMP)/FULL
DISTRIB_R := $(DISTRIB_BUILD_TMP)/R


all:	lib R 

lib:
	make --directory=$@



R:
	make --directory=interfaces $@


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
	-(cd $(DISTRIB_FULL); tar cvf pdq.tar pdq; gzip pdq.tar)
	-rm -rf $(DISTRIB_FULL)/pdq
	-mv $(DISTRIB_FULL)/pdq.tar.gz $(DISTRIB_FULL)/PDQ-$(PDQ_VERSION).tar.gz
	-make --directory=interfaces dist
	make clean

