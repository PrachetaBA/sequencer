echo "Reading from sequencer_rerun.csv"
while IFS=, read -r col1 col2 col3 col4
do
	sbatch npr_job.sh $col1 $col2 $col3 $col4
done < sequencer_rerun.csv
