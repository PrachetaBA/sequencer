#! /bin/bash

if [ ! -f $OpenNMT_py/preprocess.py ]; then
    print "OpenNMT_py environment variable should be set"
    exit 1
fi
if [ ! -d $data_path ]; then
    data_path=`/bin/pwd`
fi
cd $OpenNMT_py
python preprocess.py -train_src $data_path/src-train.txt -train_tgt $data_path/tgt-train.txt -valid_src $data_path/src-val.txt -valid_tgt $data_path/tgt-val.txt -src_seq_length 1010 -tgt_seq_length 100 -src_vocab_size 1000 -tgt_vocab_size 1000 -dynamic_dict -share_vocab -save_data $data_path/final 2>&1 > $data_path/preprocess.out

