# setup.py
#
#  $Id$
#
#---------------------------------------------------------------------

from distutils.core import setup, Extension

#---------------------------------------------------------------------

setup(name='pdq',
  version='1.1.0',
  description='PDQ Python Wrapper',
  author='Peter Harding',
  author_email='plh@pha.com.au',
  url='http://www.prettydamnquick.net',
  ext_modules=[
      Extension(
         "_pdq",
         ["pdq_wrap.c"],
         include_dirs  = ["../include"],
         define_macros = [('DEBUG',1),('HOME',1)],
         undef_macros  = ['XXX', 'YYY'],
         library_dirs  = ['/usr/local/lib','../lib'],
         libraries     = ['pdq']
      )
   ]
)

#---------------------------------------------------------------------

