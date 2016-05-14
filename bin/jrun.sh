#!/bin/sh
#
#  Purpose: Run a Java program
#
#  $Id$
#
#---------------------------------------------------------------------

# set -x

# export JAVA_HOME=/c/PROGRA~1/Java/j2sdk1.4.2_08

[ $VERBOSE ] && echo "JAVA_HOME => $JAVA_HOME"

ARGS=$*

WRK=`pwd`; export WRK

#CLASSPATH="$PDQ/java/lib/pdq.jar;$PDQ/java/lib/braju.jar;$PDQ/java/classes;."; export CLASSPATH

JPDQ="c:\cygwin\home\plh\pdq\java"
CLASSPATH="$JPDQ\lib\pdq.jar;$JPDQ\lib\braju.jar;$JPDQ\classes;."; export CLASSPATH

[ $VERBOSE ] && echo "CLASSPATH => $CLASSPATH"

V=-verbose
V=

for PROGRAM in $ARGS ; do
   [ $VERBOSE ] && echo $PROGRAM
   if [ ! -f ${PROGRAM}.class ] ; then
      $JAVA_HOME/bin/javac $V -classpath $CLASSPATH ${PROGRAM}.java
   fi

   echo $JAVA_HOME/bin/java $V -cp $CLASSPATH $PROGRAM
   $JAVA_HOME/bin/java $V -cp $CLASSPATH $PROGRAM
done

