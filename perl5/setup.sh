#!/bin/sh
#
#  $Id$
#

make clean

ar xv ../lib/libpdq.a

cp ../lib/*.o .

perl Makefile.PL

make install

