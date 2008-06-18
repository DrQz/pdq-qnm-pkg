# setup.py
#
#  $Id$
#
#---------------------------------------------------------------------

from distutils.core import setup, Extension

#---------------------------------------------------------------------

setup(name='pdq',
  version='1.2.0',
  description='PDQ Python Wrapper',
  author='Phil Feller',
  author_email='phil@philfeller.com',
  url='http://www.perfdynamics.com/Tools/PDQcode.html',
  py_modules=['pdq'],
  ext_modules=[
      Extension(
         '_pdq',
         sources       = ['pdq_wrap.c'],
         define_macros = [('DEBUG',1),('HOME',1)],
         library_dirs  = ['/usr/local/lib','../lib'],
         libraries     = ['pdq']
      )
   ]
)

#---------------------------------------------------------------------

