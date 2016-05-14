#
#  Makefile -- Meta makefile for building PDQ R Package
#
.PHONY:  install set_up_package dist clean
COPY := cp
SWIG := swig
MV := mv
SOURCETARGET := pdq/src
HEADERSTARGET := pdq/src
PDQSOURCES := $(wildcard ../lib/*.c)
PDQHEADERS := $(wildcard ../lib/*.h)
SOURCES := $(subst ../lib,pdq/src,$(PDQSOURCES))
HEADERS := $(subst ../lib,pdq/src,$(PDQHEADERS))


install: set_up_package
	R CMD INSTALL pdq

dist: set_up_package
	R CMD build pdq

set_up_package: $(HEADERS) $(SOURCES) 

swig: pdq/src/pdq.c

$(SOURCES): pdq/src/%.c:../lib/%.c
	$(COPY) $< $@

$(HEADERS): pdq/src/%.h:../lib/%.h
	$(COPY) $< $@

pdq/src/pdq.c: ../pdq.i
	$(SWIG) -r -o pdq/src/pdq.c ../pdq.i
	$(MV)	pdq/src/pdq.R pdq/R

clean:
	$(RM)  $(SOURCES) 
	$(RM) $(HEADERS)
	$(RM)  -r pdq/src-i386 pdq/src-x86_64
	$(RM)  -f *.tar.gz
