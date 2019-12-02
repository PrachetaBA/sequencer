#!/bin/bash

echo "Defects4J_oneLinerFix.sh start"

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DEFECTS4J_DIR=$CURRENT_DIR/Defects4J_projects
echo "Creating directory 'Defects4J_projects'"
if [ ! -d $DEFECTS4J_DIR ]; then
   mkdir -p $DEFECTS4J_DIR
fi
echo

DEFECTS4J_PATCHES_DIR=$CURRENT_DIR/Defects4J_patches
echo "Creating directory 'Defects4J_patches'"
if [ ! -d $DEFECTS4J_PATCHES_DIR ]; then
   mkdir -p $DEFECTS4J_PATCHES_DIR
fi
echo

#col1 = $1, col2=#2, col3=$3, col4=$4

BUG_PROJECT=${DEFECTS4J_DIR}/$1_$2_$4
if [ -d $BUG_PROJECT ]; then
   echo "Deleting current existing $BUG_PROJECT"
   rm -rf $BUG_PROJECT
fi

echo "Creating $BUG_PROJECT"
mkdir -p $BUG_PROJECT
echo "Checking out $1_$2 to ${BUG_PROJECT}"
defects4j checkout -p $1 -v ${2}b -w $BUG_PROJECT &>/dev/null
echo

echo "Generating patches for ${1}_${2}_${4}"
$CURRENT_DIR/../sequencer-predict.sh --buggy_file=$BUG_PROJECT/$3 --buggy_line=$4 --beam_size=50 --output=$DEFECTS4J_PATCHES_DIR/${1}_${2}_${4}
echo

echo "Running test on all patches for ${1}_${2}"
python3 $CURRENT_DIR/validatePatch.py $DEFECTS4J_PATCHES_DIR/${1}_${2}_${4} $BUG_PROJECT $BUG_PROJECT/$3
echo

echo "Deleting ${BUG_PROJECT}"
rm -rf $BUG_PROJECT
echo

# echo "Found $(find $DEFECTS4J_PATCHES_DIR -name '*_passed' | wc -l | awk '{print $1}') test-suite adequate patches in total."
# echo "Found passing patches for $(find $DEFECTS4J_PATCHES_DIR -name '*_passed' -exec dirname {} \; | sort -u | wc -l | awk '{print $1}') projects"
# echo "Defects4J_oneLinerFix.sh done"
# echo
exit 0
