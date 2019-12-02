#!/usr/bin/python
import sys
from itertools import islice
from statistics import mean

def check_acc(pred,tgt):
	'''
	Check accuracy by using the logic defined
	'''
	tgt_words = tgt.split()
	pred_words = pred.split()
	# print(tgt_words)
	# print(pred_words)

	if len(pred_words) != len(tgt_words):
		return 0.0
	
	no_tokens = len(tgt_words)
	correct_tokens = 0
	#Check each prediction word by word
	for k,v in zip(tgt_words, pred_words):
		if k == v:
			correct_tokens+=1
		elif v == '<unk>':
			correct_tokens+=1 

	return (correct_tokens/no_tokens)


def check_acc_unk(pred, tgt):
	'''
	Check accuracy by using the logic defined
	'''
	tgt_words = tgt.split()
	pred_words = pred.split()
	# print(tgt_words)
	# print(pred_words)
	
	no_tokens = len(tgt_words)
	correct_tokens = 0
	#Check each prediction word by word
	for k,v in zip(tgt_words, pred_words):
		if k == v:
			correct_tokens+=1

	return (correct_tokens/no_tokens)

def get_accuracy(pred):
	# put file numbers as sys args
	pred_file = '../logs/pred-test_'+str(pred)+'.txt'
	tgt_file = '../tgt-val.txt'

	start = 0
	counter = 0
	# n_best is also a parameter 
	n_best = 30

	global_accuracy = []
	while True:
		with open(tgt_file, 'r') as f2:
			line2 = f2.readlines()
			try:
				tgt_line = line2[counter]
			except IndexError as e:
				break 

		with open(pred_file, 'r') as f1:
			line1_gen = islice(f1, start, start+n_best)
			acc_list = []
			for line in line1_gen:
				acc_list.append(check_acc(line, tgt_line))
			global_accuracy.append(max(acc_list))

		start += n_best
		counter += 1 

	mean_accuracy = mean(global_accuracy)
	# print('Max global accuracy: ',max(global_accuracy))
	# print('Mean among the 3000 predictions: ',mean_accuracy)
	return mean_accuracy