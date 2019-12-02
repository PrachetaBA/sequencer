#! /bin/bash
#SBATCH --job-name=npr_translate
#SBATCH --partition=2080ti-short
#SBATCH --time=0-04:00
#SBATCH --mem=80GB
#SBATCH --output=gypsum_output/res_%j.out

export CUDA_VISIBLE_DEVICES=0
export THC_CACHING_ALLOCATOR=0
export OpenNMT_py=../../src/lib/OpenNMT-py/


data_path=$(pwd)

cd $OpenNMT_py



python translate.py -model $data_path/model_full.pt -src $data_path/src-test.txt -beam_size 50 -n_best 1 -output $data_path/pred-test_beam50_full.txt -dynamic_dict 2>&1 > $data_path/translate50_full.out
