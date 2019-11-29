#! /bin/bash
#SBATCH --job-name=npr_train
#SBATCH --partition=titanx-short
#SBATCH --time=0-04:00
#SBATCH --mem=8GB
#SBATCH --ntasks-per-node=8
#SBATCH --output=gypsum_output/model_full.out

export CUDA_VISIBLE_DEVICES=0
export THC_CACHING_ALLOCATOR=0
export OpenNMT_py=../../src/lib/OpenNMT-py/

if [ ! -f $OpenNMT_py/preprocess.py ]; then
    print "OpenNMT_py environment variable should be set"
    exit 1
fi

data_path=$(pwd)

cd $OpenNMT_py

python train.py -data $data_path/models/model -encoder_type cnn -enc_layers 4 \
-decoder_type cnn -dec_layers 4 -cnn_kernel_width 3 -global_attention general \
-batch_size 32 -word_vec_size 256 -copy-attn -reuse_copy_attn -bridge -train_steps 3000 -gpu_ranks 0 \
-save_checkpoint_steps 3000 -early_stopping 5 -log_file $data_path/logs/model_full_log \
-save_model $data_path/models/model_full > $data_path/models/model_full.out
#-tensorboard -tensorboard_log_dir $data_path/logs/model_v1_tensorboard \
echo "train.sh complete" >> $data_path/train.out
