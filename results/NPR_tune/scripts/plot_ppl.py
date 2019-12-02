import matplotlib.pyplot as plt 
import numpy as np
import os 
import sys 
import re 

file = 'model_t2.txt'
steps = []
ppl = []
accuracy = []
with open(file, 'r') as f: 
	line = f.readlines()
	for l in line:
		if 'Step' in l and 'acc' in l:
			try:
				string = re.sub('\s+',' ',l).strip()
				string = string.split(' ')
				s = int(string[4].rstrip(';').split('/')[0])
				steps.append(s)
				a = float(string[6].rstrip(';'))
				accuracy.append(a)
				p = float(string[8].rstrip(';'))
				ppl.append(p)
				# print('s: ', s, ' a: ', a, ' p: ', p)
			except ValueError as e:
				print(e)
				print(l)

plt.style.use('seaborn-darkgrid')
plt.plot(steps, ppl, label='Perplexity')
plt.plot(steps, accuracy, label='Accuracy')
plt.title('Best Model')
plt.xlabel('Training Steps')
plt.legend(fontsize=9)
plt.show()
