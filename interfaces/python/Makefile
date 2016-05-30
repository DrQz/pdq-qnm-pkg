# 
#       Author:  Peter Harding  <plh@pha.com.au>
# 
#                Peter Harding & Associates Pty. Ltd.
#                Level 6,
#                170 Queen Street,
#                MELBOURNE, VIC, 3004
# 
#                Phone:   03 9641 2222
#                Fax:     03 9641 2200
#                Mobile:  0418 375 085
# 
#   Copyright (C) Peter Harding, 2003-2004,  All rights reserved
# 
#           @(#) [6.1.1] Makefile 01/13/2012
# 
#   $Id$
#---------------------------------------------------------------------
COPY := cp
SWIG := swig
SOURCETARGET := .
HEADERSTARGET := .
PDQSOURCES := $(wildcard ../../lib/*.c)
PDQHEADERS := $(wildcard ../../lib/*.h)
SOURCES := $(notdir $(PDQSOURCES))
HEADERS := $(notdir $(PDQHEADERS))

.PHONY:  all install build setup dist

all:	install

#---------------------------------------------------------------------

install: build
	python setup.py install

build: setup
	python setup.py build

setup: $(SOURCES) $(HEADERS) 

swig: pdq_wrap.c

$(SOURCES): %.c:../../lib/%.c
	$(COPY) $< $@

$(HEADERS): %.h:../../lib/%.h
	$(COPY) $< $@

pdq_wrap.c: ../pdq.i
	swig -python -o pdq_wrap.c ../pdq.i


#---------------------------------------------------------------------

clean:
	rm -rf build dist 
	rm -f $(SOURCES) $(HEADERS) MANIFEST

dist: setup
	python setup.py sdist
#---------------------------------------------------------------------
#
# Note:
#
#   The setup copies a shared object into a system
#   wide area [.../site-packages].  If you are building
#   as an unprivileged user you will not be able to do
#   this installation and will need to install to a
#   directory you do have access to [such as ~/lib]
#   and use a PYTHON_PATH to reference it.
#
#  
#  PY_PKG    = /usr/lib/pythonV.N/site-packages/
#  
#  BUILD_DIR = build/lib.linux-i686-2.2
#  BUILD_DIR = build/lib.cygwin-1.5.3-i686-2.3
#  
#  SHARED_OBJ = pdq.so        # Under UNIX/Linux
#  SHARED_OBJ = pdq.dll       # Windows
#
#  build: -->
#         cp $(BUILD_DIR)/$(SHARED_OBJ) $(PY_PKG)
#
#---------------------------------------------------------------------
