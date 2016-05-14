#  $Id$
#
#---------------------------------------------------------------------
EXAMPLES := $(wildcard examples/ppa_1998/chap*)
ECHO := /bin/echo
ECHO_OPTION := -e
ECHO_MESSAGE := "\n\nMaking chapter $@ PDQ files ...\n"
.PHONY: all lib perl5 python R examples $(EXAMPLES)


PDQ_VERSION=$(shell tools/getversion)


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
#	-(cd perl5; swig -perl5 -o pdq_wrap.c ../pdq.i)
#	-(cd python; swig -python -o pdq_wrap.c ../pdq.i)
#	-(cd R; swig -r -o pdq/src/pdq.c ../pdq.i; mv pdq/src/pdq.R pdq/R)

#---------------------------------------------------------------------

#test:
#	-(cd examples; make test)

# test:
# 	for num in $(CHPLIST); do\
# 		echo;echo; \
# 		echo "Making chapter $$num PDQ files ..."; \
# 		(cd examples/ppa_1998/chap$$num; make -f Makefile all);\
# 	done
test:
	make --directory=examples test

#---------------------------------------------------------------------

clean:
	-/bin/rm *~ 
	make --directory=lib clean
	make --directory=perl5 -f setup.mk clean
	make --directory=examples clean
	make --directory=python clean
	make --directory=R clean

#---------------------------------------------------------------------

dist: swig
	@echo $(PDQ_VERSION)
	-rm -rf /tmp/pdq /tmp/pdq.tar /tmp/pdq.tar.gz
	-mkdir /tmp/pdq
	-cp -r . /tmp/pdq
	-(cd /tmp/pdq; find . -name CVS -exec rm -rf \{\} \;)
	-(cd /tmp/pdq; rm headache.cfg header.txt)
	-(cd /tmp; tar cvf pdq.tar pdq; gzip pdq.tar)
	-rm -rf /tmp/pdq
	-mv /tmp/pdq.tar.gz ../PDQ-$(PDQ_VERSION).tar.gz
	make --directory=R dist
	make --directory=perl5 -f setup.mk dist
	make --directory=python dist

#---------------------------------------------------------------------
