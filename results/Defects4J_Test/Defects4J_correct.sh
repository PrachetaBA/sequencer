#!/bin/bash

echo "Defects4J_correct.sh start"

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DEFECTS4J_DIR=$CURRENT_DIR/Defects4J_correct
if [ ! -d $DEFECTS4J_DIR ]; then
   mkdir -p $DEFECTS4J_DIR
fi
echo

BUG_PROJECT=${DEFECTS4J_DIR}/${1}_${2}
if [ -d $BUG_PROJECT ]; then
   echo "Deleting current existing $BUG_PROJECT"
   rm -rf $BUG_PROJECT
fi

echo "Creating $BUG_PROJECT"
mkdir -p $BUG_PROJECT
echo "Checking out ${1}_${2} to ${BUG_PROJECT}"
defects4j checkout -p ${1} -v ${2}f -w $BUG_PROJECT 
echo
