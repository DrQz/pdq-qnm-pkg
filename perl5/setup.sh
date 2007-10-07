#!/bin/sh
#
#  $Id$
#

make clean

ar xv ../lib/libpdq.a

# swig -perl5 pdq.i

perl Makefile.PL

make install

