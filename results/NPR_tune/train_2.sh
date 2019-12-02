#! /bin/bash
#SBATCH --job-name=npr_train
#SBATCH --partition=titanx-long
#SBATCH --mem=20GB

export CUDA_VISIBLE_DEVICES=0
export THC_CACHING_ALLOCATOR=0
export OpenNMT_py=../../src/lib/OpenNMT-py/

if [ ! -f $OpenNMT_py/preprocess.py ]; then
    print "OpenNMT_py environment variable should be set"
    exit 1
fi

data_path=$(pwd)

cd $OpenNMT_py

python train.py -data $data_path/models/model_p$1 -encoder_type cnn -enc_layers $2 \
-decoder_type cnn -dec_layers $2 -cnn_kernel_width 3 -global_attention general \
-batch_size 16 -word_vec_size 256 -train_steps 20000 -dropout $3 \
-save_checkpoint_steps 10000 -optim adam -learning_rate 0.0002 -early_stopping 5 -gpu_ranks 0 \
-save_model $data_path/models/model_t$4 > $data_path/logs/train_t$4.out