#!/usr/bin/python
import subprocess
import os

models = []

all_preds = os.listdir('../logs/')
for pred in all_preds:
	if pred.startswith('pred-test_'):
		model = pred.split('_')[1].rstrip('.txt')
		models.append(model)

'''
for m in models:
	if m != str(127) or m != str(129):
		print('Model no: ', m)
		subprocess.call(["python", "check_acc.py", m])
'''