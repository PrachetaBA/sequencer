#! /bin/bash
#SBATCH --job-name=npr_translate
#SBATCH --partition=titanx-long
#SBATCH --mem=20GB

export CUDA_VISIBLE_DEVICES=0
export THC_CACHING_ALLOCATOR=0
export OpenNMT_py=../../src/lib/OpenNMT-py/


data_path=$(pwd)

cd $OpenNMT_py
python translate.py -model $data_path/models/model_t$1_step_20000.pt \
-src $data_path/src-test.txt -beam_size 30 -n_best 30 -output $data_path/logs/pred-test_$1.txt \
-dynamic_dict 2>&1 > $data_path/logs/translate_out_$1.txt
