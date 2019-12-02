import javalang
import linecache
import pickle

correct_file = 'Defects4J_truth.pickle'

fixed_line = {}

all_lines = 'Defects4J_testprg.csv'
with open(all_lines, 'r') as f1:
	for line in f1:
		final_line = ''
		l = line.rstrip('\n').split(',')
		filepath = 'Defects4J_correct/'+l[0]+'_'+l[1]+'/'+l[2]
		buggyline = l[3]

		correct_line = linecache.getline(filepath, int(buggyline))
		# print('Correct line is: ', correct_line)

		c_line = []
		c_words = list(javalang.tokenizer.tokenize(correct_line))
		for w in c_words:
		    c_line.append(w.value)
		final_line = ''.join(c_line)
		fixed_line[l[0]+'_'+l[1]] = final_line

with open(correct_file, "wb") as f:
	pickle.dump(fixed_line, f)