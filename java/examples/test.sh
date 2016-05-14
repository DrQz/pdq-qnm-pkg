#!/bin/sh
#
#  $Id$
#
#---------------------------------------------------------------------

# set -x

#  Bad
SCRIPTS="Ch3_Feedback"

SCRIPTS="Ch7_Abcache"
SCRIPTS="Ch7_Multibus"

# and CH8_SCRIPTS are ancient and incomplete!

#  OK
CH2_SCRIPTS="\
   Ch2_Closed
   Ch2_Open"

CH3_SCRIPTS="\
   Ch3_Closed
   Ch3_MCTest
   Ch3_MultiClass
   Ch3_Passport
   Ch3_ShadowCPU
   Ch3_SimpleSeries
   Ch3_MCTest"

CH6_SCRIPTS="\
   Ch6_DBC"

CH8_SCRIPTS="\
   Ch8_Baseline
   Ch8_Scaleup
   Ch8_Upgrade1
   Ch8_Upgrade2"

CH9_SCRIPTS="\
   Ch9_HTTP
   Ch9_IIS
   Ch9_eBiz"

SCRIPTS="\
   $CH2_SCRIPTS
   $CH3_SCRIPTS
   $CH6_SCRIPTS
   $CH9_SCRIPTS
"

SCRIPTS="Ch7_Abcache"

#---------------------------------------------------------------------

STR=`uname -a | sed 's/^.* //'`

# echo $STR

if [ ${STR} = "Cygwin" ] ; then
   TYPE="Intel"
else
   TYPE="UNIX"
fi

# echo $TYPE

EXTS='exe py pl'

#----- Need a way to handle scripts which take arguments... -----
# CUST_SCRIPTS="erlang"
# CUST_ARGS="12 4"

pwd

for SCRIPT in $SCRIPTS; do
   egrep -v 'Using:|Ver:|of :' ${SCRIPT}.out >  ${SCRIPT}.tst

   ./run.sh ${SCRIPT} | egrep -v 'Using:|Ver:|of :' | sed 's///' >  ${SCRIPT}_java.tst

   diff ${SCRIPT}_java.tst ${SCRIPT}.tst > diff.log

   NO=`wc -l diff.log | awk '{print $1}'`

   echo "NO -> $NO"

   if [ $NO -eq 0 ] ; then
      echo "$SCRIPT - OK"
   else
      echo "$SCRIPT - Failed: check ${SCRIPT}"
   fi

   # /bin/rm -f ${SCRIPT}.tst
done

#---------------------------------------------------------------------

