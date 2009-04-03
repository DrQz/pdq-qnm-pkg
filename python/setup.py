###############################################################################
#  Copyright (C) 1994 - 2008, Performance Dynamics Company                    #
#                                                                             #
#  This software is licensed as described in the file COPYING, which          #
#  you should have received as part of this distribution. The terms           #
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.    #
#                                                                             #
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell   #
#  copies of the Software, and permit persons to whom the Software is         #
#  furnished to do so, under the terms of the COPYING file.                   #
#                                                                             #
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  #
#  KIND, either express or implied.                                           #
###############################################################################

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

