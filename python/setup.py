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
#from setuptools import setup, Extension
import sys, os, string, re, distutils.sysconfig


def drop_from_config_var(variable, pattern):
    '''Remove pattern from config variable'''
    v = distutils.sysconfig.get_config_var(variable);
    if re.search(pattern, v):
         nv = re.sub(pattern, '', v)
         distutils.sysconfig.get_config_vars()[variable] = nv

for var in ("CFLAGS", "BASECFLAGS", "PY_CFLAGS"):
    drop_from_config_var(var, '-Wno-long-double')

#---------------------------------------------------------------------

setup(name='pdq',
  version='6.1.1',
  description='PDQ Python Wrapper',
  author='Phil Feller',
  author_email='phil@philfeller.com',
  url='http://www.perfdynamics.com/Tools/PDQcode.html',
#  package=['pdq'],
  py_modules=['pdq'],
  ext_modules=[
      Extension(
         '_pdq',
         sources       = ['pdq_wrap.c',
                          'MVA_Approx.c',
                          'MVA_Canon.c',
                          'MVA_Solve.c',
                          'PDQ_Build.c',
                          'PDQ_Exact.c',
                          'PDQ_Globals.c',
                          'PDQ_MServer.c',
                          'PDQ_Report.c',
                          'PDQ_Utils.c'
                          ],
          
         define_macros = [('DEBUG',1),('HOME',1)],
#         library_dirs  = ['/usr/local/lib','../lib'],
#         libraries     = ['pdq']

      )
   ]
)

#---------------------------------------------------------------------


