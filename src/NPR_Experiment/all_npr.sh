echo "Reading from npr_bugs.csv"
while IFS=, read -r col1 col2 col3 col4
do
	sbatch npr_job.sh $col1 $col2 $col3 $col4
done < npr_bugs.csv
