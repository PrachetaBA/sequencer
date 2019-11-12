#!/bin/bash
FILENAME=sqr_closure_metadata.csv
split -l 10 $FILENAME xyz  # Split the file into chunks of 10 lines each
n=1
for f in xyz*              # Go through all newly created chunks
do
   cat $f >> sqr_closure_${n}.csv      # Add in the 20 lines from the "split" command
   rm $f                   # Remove temporary file
   ((n++))                 # Increment name of output part
done