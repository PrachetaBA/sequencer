#!/usr/bin/python
import subprocess
import pickle
import pandas as pd 
import os 
import re
from check_acc import get_accuracy 

file_1 = '../preproc_params.pickle'
with open(file_1, 'rb') as f:
	preproc_1 = pickle.load(f)

file_2 = '../preproc_params_highvocab.pickle'
with open(file_2, 'rb') as f:
	preproc_2 = pickle.load(f)

pre_1 = pd.DataFrame.from_dict(preproc_1, orient='index')
pre_2 = pd.DataFrame.from_dict(preproc_2, orient='index')
preproc_params = pd.concat([pre_1, pre_2])
preproc_params.index.name = 'preproc_model'
# print(preproc_params)

train_params = pd.read_csv('train_params.csv')
train_params.index.name = 'model'
train_params.drop(['Unnamed: 0'], inplace=True, axis=1)
# print(train_params)

hyperparams = pd.merge(preproc_params, train_params, on='preproc_model')
hyperparams.drop(['preproc_model'], inplace=True, axis=1)
hyperparams.index.name = 'model'

#Add perplexity at the end of cross validation, and the average pred score, + accuracy from our calculation 
models = {}
all_files = os.listdir('../logs/')
for pred in all_files:
	# if pred.startswith('pred-test_'):
	# 	model = pred.split('_')[1].rstrip('.txt')
	# 	models[model] = None
	if pred.startswith('translate_out_'):
		fname = '../logs/'+pred
		with open(fname, 'r') as f:
			line = f.readline()
			if line:
				string = re.sub('\s+',' ',line).strip()
				l = string.split(',')
				avg_score = l[0]
				avg_score = avg_score.split(':')[1]
				pplx = l[1]
				pplx = pplx.split(':')[1]
				model = pred.split('_')[2].rstrip('.txt')
				acc = get_accuracy(model)
				models[int(model)] = {'score':avg_score, 'pplx': pplx, 'acc':acc}

training = pd.DataFrame.from_dict(models, orient='index')

all_params = hyperparams.join(training)
all_params.to_csv('training_stats.csv')

'''
# OLD 
# Training parameters did not include some information, added to csv file
file_3 = '../train_params.pickle'
with open(file_3, 'rb') as f:
	train_1 = pickle.load(f)

file_4 = '../train_params_v2.pickle'
with open(file_4, 'rb') as f:
	train_2 = pickle.load(f)

file_5 = '../train_params_v3.pickle'
with open(file_5, 'rb') as f:
	train_3 = pickle.load(f)

file_6 = '../train_params_v4.pickle'
with open(file_6, 'rb') as f:
	train_4 = pickle.load(f)

file_7 = '../train_params_highvocab.pickle'
with open(file_7, 'rb') as f:
	train_5 = pickle.load(f)

tr_1 = pd.DataFrame.from_dict(train_1, orient='index')
tr_2 = pd.DataFrame.from_dict(train_2, orient='index')
tr_3 = pd.DataFrame.from_dict(train_3, orient='index')
tr_4 = pd.DataFrame.from_dict(train_4, orient='index')
tr_5 = pd.DataFrame.from_dict(train_5, orient='index')
train_params = pd.concat([tr_1, tr_2, tr_3, tr_4, tr_5])
print(train_params)

train_params.to_csv('train_params.csv')
'''
