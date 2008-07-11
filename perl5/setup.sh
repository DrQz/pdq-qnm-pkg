#!/bin/sh
#
#  $Id$
#

if [ -f Makefile ]; then
make clean
fi

if [ -f ../lib/libpdq.a ]; then
ar xv ../lib/libpdq.a
else
cp ../lib/libpdq.so .
fi

cp ../lib/*.o .

if [ `uname` = 'SunOS' ]; then
perl Makefile.PL CC=gcc LD=gcc
egrep -v '^(CCCDLFLAGS|OPTIMIZE)' Makefile > Makefile.new
mv Makefile.new Makefile
else
perl Makefile.PL
fi

make install

