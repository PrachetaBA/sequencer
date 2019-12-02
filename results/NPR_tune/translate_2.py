import random
import numpy as np 
import subprocess
import pickle
import os

predict_file = 'predict_params_highvocab.pickle'
predict = []

for model_number in range(5000,5006):
	file_path = 'models/model_t'+str(model_number)+'_step_20000.pt'
	if os.path.isfile(file_path):
		cmd = 'sbatch --output=logs/translate_' + str(model_number) + '.out translate_2.sh' + \
		' ' + str(model_number)

		subprocess.call(cmd, shell=True)
			
		predict.append(model_number)


#Write parameter to model mapping to a dictionary which is stored in a pickle file
with open(predict_file, "wb") as f:
	pickle.dump(predict, f)
