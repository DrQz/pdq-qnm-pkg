#!/bin/sh
#
#  $Id$
#
#---------------------------------------------------------------------

# set -x

SCRIPTS="dbc"

#---------------------------------------------------------------------

STR=`uname -a | sed 's/^.* //'`

# echo $STR

if [ ${STR} = "Cygwin" ] ; then
   TYPE="Intel"
else
   TYPE="UNIX"
fi

# echo $TYPE

EXTS='exe pl'

#---------------------------------------------------------------------

pwd

for SCRIPT in $SCRIPTS; do
   egrep -v 'Using:|Ver:|of :' ${SCRIPT}.out >  ${SCRIPT}.tst

   for EXT in $EXTS ; do
      if [ \( $EXT = "exe" \) -a \( $TYPE != 'Intel' \) ] ; then
         ./${SCRIPT}        | egrep -v 'Using:|Ver:|of :' >  ${SCRIPT}_${EXT}.tst
      else
         ./${SCRIPT}.${EXT} | egrep -v 'Using:|Ver:|of :' >  ${SCRIPT}_${EXT}.tst
      fi

      diff ${SCRIPT}_${EXT}.tst ${SCRIPT}.tst
      diff ${SCRIPT}_${EXT}.tst ${SCRIPT}.tst > diff.log

      NO=`wc -l diff.log | awk '{print $1}'`

      if [ $NO -eq 0 ] ; then
         echo "$SCRIPT $EXT - OK"
      else
         echo "$SCRIPT $EXT - Failed: check ${SCRIPT}_${EXT}.tst"
      fi
   done

   /bin/rm -f ${SCRIPT}.tst
done

#---------------------------------------------------------------------

