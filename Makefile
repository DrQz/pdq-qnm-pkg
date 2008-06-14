#
#  $Id$
#
#---------------------------------------------------------------------

all:
	./Makeall

perl:
	-(cd perl5; ./setup.sh)

python:
	-(cd python; make)

#---------------------------------------------------------------------

swig:
	-(cd perl5; swig -perl5 -o pdq_wrap.c ../pdq.i)
	-(cd python; swig -python -o pdq_wrap.c ../pdq.i)

#---------------------------------------------------------------------

test:
	-(cd examples; make test)

#---------------------------------------------------------------------

clean:
	-/bin/rm *~ 
	-(cd lib; make clean)
	-(cd examples; make clean)
	-(cd perl5; make clean)
	-(cd python; make clean)

#---------------------------------------------------------------------

dist:
	-rm -rf /tmp/pdq /tmp/pdq.tar /tmp/pdq.tar.gz
	-mkdir /tmp/pdq
	-cp -r . /tmp/pdq
	-(cd /tmp/pdq; find . -name CVS -exec rm -rf \{\} \;)
	-(cd /tmp; tar cvf pdq.tar pdq; gzip pdq.tar)
	-rm -rf /tmp/pdq
	-mv /tmp/pdq.tar.gz ..

#---------------------------------------------------------------------

