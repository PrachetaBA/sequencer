#! /bin/bash
#SBATCH --job-name=npr_preprocess
#SBATCH --partition=m40-short
#SBATCH --time=0-04:00
#SBATCH --output=gypsum_output/res_%j.out

export CUDA_VISIBLE_DEVICES=0
export THC_CACHING_ALLOCATOR=0
export OpenNMT_py=../../src/lib/OpenNMT-py/

if [ ! -f $OpenNMT_py/preprocess.py ]; then
    print "OpenNMT_py environment variable should be set"
    exit 1
fi

data_path=$(pwd)

cd $OpenNMT_py
python preprocess.py -train_src $data_path/src-train.txt -train_tgt $data_path/tgt-train.txt \
 -valid_src $data_path/src-val.txt -valid_tgt $data_path/tgt-val.txt -src_seq_length 1010 \
  -tgt_seq_length 100 -src_vocab_size 1000 -tgt_vocab_size 1000 -dynamic_dict \
  -share_vocab -overwrite -save_data $data_path/models/model 2>&1 > $data_path/preprocess.out
