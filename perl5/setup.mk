#
#  setup.mk -- Meta makefile for building PDQ perl module
#
.PHONY:  install_module build_module dist set_up Makefile
COPY := cp
SWIG := swig
SOURCETARGET := .
HEADERSTARGET := .
PDQSOURCES := $(wildcard ../lib/*.c)
PDQHEADERS := $(wildcard ../lib/*.h)
SOURCES := $(notdir $(PDQSOURCES))
HEADERS := $(notdir $(PDQHEADERS))


install_module: build_module
	make install

build_module: set_up
	perl Makefile.PL
	make

dist: set_up
	make dist

set_up: $(SOURCES) $(HEADERS)  Makefile

swig: pdq_wrap.c

Makefile:
	perl Makefile.PL

$(SOURCES): %.c:../lib/%.c
	$(COPY) $< $@

$(HEADERS): %.h:../lib/%.h
	$(COPY) $< $@

pdq_wrap.c: ../pdq.i
	$(SWIG) -perl5 -o pdq_wrap.c ../pdq.i
clean:
	$(if $(wildcard Makefile), make clean)
	$(RM)  $(SOURCES) 
	$(RM)  $(HEADERS) 
	$(RM) *.o
	$(RM) *.tar.gz
	$(RM) *.bak
	$(RM) *.old
	$(RM) test.out
