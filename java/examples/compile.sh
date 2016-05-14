#!/bin/sh
#
#  Purpose: Compile a Java program
#
#  $Id$
#
#---------------------------------------------------------------------

# export JAVA_HOME=/c/PROGRA~1/Java/j2sdk1.4.2_08

echo "JAVA_HOME => $JAVA_HOME"

ARGS=$*

WRK=`pwd`; export WRK

CLASSPATH="..\lib\braju.jar;..\lib\pdq.jar;."; export CLASSPATH

echo "CLASSPATH => $CLASSPATH"

V=-verbose
V=

for ARG in $ARGS; do
   $JAVA_HOME/bin/javac $V -d . -classpath $CLASSPATH $ARG
done

