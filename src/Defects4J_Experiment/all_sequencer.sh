echo "Reading from sequencer_metadata.csv"
while IFS=, read -r col1 col2 col3 col4
do
	sbatch npr_job.sh $col1 $col2 $col3 $col4
done < sequencer_metadata.csv
