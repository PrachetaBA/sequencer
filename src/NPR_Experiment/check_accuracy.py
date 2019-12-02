import sys
from itertools import islice
from statistics import mean
import pickle
import javalang 

# put file numbers as sys args
pred_file = sys.argv[3]

with open('Defects4J_truth.pickle','rb') as f:
	truth_dict = pickle.load(f)

start = 0
# n_best is also a parameter 
n_best = sys.argv[2]

global_accuracy = 0.0

key = sys.argv[1].split('_')
tgt_key = key[0]+'_'+key[1]
tgt_string = truth_dict[tgt_key]

correct_line = []
tgt_line = list(javalang.tokenizer.tokenize(tgt_string))
for w in tgt_line:
	correct_line.append(w.value)

def check_acc(pred,tgt):
	'''
	Check accuracy by using the logic defined
	'''
	pred_words = pred.split()
	
		
	if len(pred_words) != len(tgt):
		return 0.0
	
	no_tokens = len(tgt)
	correct_tokens = 0
	#Check each prediction word by word
	for k,v in zip(tgt, pred_words):
		if k == v:
			correct_tokens+=1
		elif v == '<unk>':
			correct_tokens+=1 

	return (correct_tokens/no_tokens)

with open(pred_file, 'r') as f1:
	line1_gen = islice(f1, start, start+int(n_best))
	acc_list = []
	for line in line1_gen:
		accuracy = check_acc(line,correct_line)
		acc_list.append(accuracy)
	global_accuracy = max(acc_list)

print(global_accuracy)
