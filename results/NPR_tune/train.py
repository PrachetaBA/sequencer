import random
import numpy as np 
import subprocess
import pickle

train_file = 'train_params_v4.pickle'
train = {}

cnn_layers = np.random.randint(low=1, high=6, size=3)
dropout = np.random.uniform(size=2)
lr = np.random.uniform(size=3)
model_number = 130

params = {'cnn_layers':None, 'dropout':None, 'lr':None, 'preproc_model':None}

for cnn_l in cnn_layers:
	for d_out in dropout:
		for l_rate in lr:
			for preproc_model in range(1,9):

				# gpu_id = np.random.randint(low=0, high=3, size=1)
				# print("GPU ID is: ", gpu_id)
				
				params['cnn_layers'] = cnn_l
				params['dropout'] = d_out
				params['lr'] = l_rate
				params['preproc_model'] = preproc_model
				train[model_number] = params

				cmd = 'sbatch --output=logs/model_t'+str(model_number)+'.txt train.sh '+ \
				str(preproc_model) + ' ' + str(cnn_l) + ' ' + str(d_out) + ' ' + str(l_rate) + ' ' + \
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

