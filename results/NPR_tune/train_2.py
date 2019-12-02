import random
import numpy as np 
import subprocess
import pickle

train_file = 'train_params_highvocab.pickle'
train = {}

cnn_layers = np.random.choice(a=[1,2,3,4,5], size=3, replace=False)
dropout = np.random.random_sample(size=2)
model_number = 5000

params = {'cnn_layers':None, 'dropout':None, 'preproc_model':None}

for cnn_l in cnn_layers:
	for d_out in dropout:
			preproc_model = 5000
			
			params['cnn_layers'] = cnn_l
			params['dropout'] = d_out
			params['preproc_model'] = preproc_model
			train[model_number] = params

			cmd = 'sbatch --output=logs/model_t'+str(model_number)+'.txt train_2.sh '+ \
			str(preproc_model) + ' ' + str(cnn_l) + ' ' + str(d_out) + ' ' + \
			str(model_number)
			#+ ' ' + str(gpu_id[0])
			
			print(cmd)
			subprocess.call(cmd, shell=True)
			
			#increment model number
			model_number+=1 

			#re-initialize params
			params = {'cnn_layers':None, 'dropout':None, 'lr':None, 'preproc_model':None}

#Write parameter to model mapping to a dictionary which is stored in a pickle file
with open(train_file, "wb") as f:
	pickle.dump(train, f)

