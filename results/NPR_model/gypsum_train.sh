#! /bin/bash
#SBATCH --job-name=npr_train
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
if [ ! -d $data_path ]; then
        data_path=`/bin/pwd`
	export data_path
fi

echo "Print the data path $data_path"


#conda init bash
#conda activate npr-py36

cd $OpenNMT_py

echo $OpenNMT_py

python train.py -data $data_path/final -encoder_type cnn -enc_layers 4 -decoder_type cnn -dec_layers 4 -cnn_kernel_width 3 -global_attention general -batch_size 32 -word_vec_size 256 -bridge -train_steps 8000 -gpu_ranks 0 -save_checkpoint_steps 4000 -save_model $data_path/model_1 > $data_path/train.model_1.out
echo "train.sh complete" >> $data_path/train.out
