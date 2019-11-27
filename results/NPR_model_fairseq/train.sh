#! /bin/bash


if [ ! -f $OpenNMT_py/preprocess.py ]; then
    print "OpenNMT_py environment variable should be set"
    exit 1
fi
if [ ! -d $data_path ]; then
	data_path=`/bin/pwd`
fi
cd $OpenNMT_py
python train.py -data $data_path/final -encoder_type cnn -enc_layers 2 -decoder_type cnn -dec_layers 2 -cnn_kernel_width 3 -global_attention general -batch_size 32 -word_vec_size 256 -bridge -train_steps 20000 -gpu_ranks 0 -save_checkpoint_steps 10000 -save_model $data_path/final-model > $data_path/train.final.out
echo "train.sh complete" >> $data_path/train.out
