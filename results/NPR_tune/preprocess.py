import random
import numpy as np 
import subprocess
import pickle

preproc_file = 'preproc_params.pickle'
preproc = {}

#Preprocess hyperparameters
src_seq_length = [1010, 3010]
tgt_seq_length = [100, 200]
vocab_size = [1000, 3000]

model_number = 1
params = {'src_seq_length':None, 'tgt_seq_length':None, 'vocab_size':None}
for src_seq in src_seq_length:
	for tgt_seq in tgt_seq_length:
		for vocab in vocab_size:
			params['src_seq_length'] = src_seq
			params['tgt_seq_length'] = tgt_seq
			params['vocab_size'] = vocab
			preproc[model_number] = params

			cmd = 'sbatch --output=logs/preproc_p' + str(model_number) + '.out preprocess.sh ' + str(src_seq) + \
			' ' + str(tgt_seq) + ' ' + str(vocab) + ' ' + str(model_number) 
			
			subprocess.call(cmd, shell=True)
			
			#increment model number
			model_number+=1 

			#re-initialize params
			params = {'src_seq_length':None, 'tgt_seq_length':None, 'vocab_size':None}


#Write parameter to model mapping to a dictionary which is stored in a pickle file
with open(preproc_file, "wb") as f:
	pickle.dump(preproc, f)
