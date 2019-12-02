#!/bin/bash

for d in $(find Defects4J_patches/ -maxdepth 2 -type d -name "*_passed")
do
  echo "passed folder: "$d
  PATCH_NAME=`basename $d`
  echo "Basename: "$PATCH_NAME

  PATCH_NUM="$(echo $PATCH_NAME | cut -d'_' -f1)"
  echo "Patch number: "$PATCH_NUM
 # echo "Files inside passed folder `ls $d`"
  FILE_NAME=`ls $d/*.patch`
  FILES=`basename $FILE_NAME`
  FILE="$(echo $FILES | cut -d'.' -f1)"

  echo "Updated file name: "$FILES

  echo "Copy: "`cp $d/*.patch ./passed_patches/$FILE"_"$PATCH_NUM".patch"`
done
