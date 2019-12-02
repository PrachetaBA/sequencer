import sys
import javalang
import torch

vocab_file = '../models/model_p5000.vocab.pt'
vocab_fields = torch.load(vocab_file)

src_text_field = vocab_fields["src"].base_field
src_vocab = src_text_field.vocab
vocabulary = src_vocab.freqs

buggy_file = 'buggy_code.txt'
pred_file = 'pred_1.txt'

new_pred_file = 'pred_output.txt'

buggy_line = 18

with open(buggy_file, 'r') as f2:
	line2 = f2.readlines()
	try:
		tgt_line = line2[buggy_line-1]
		print(tgt_line)
	except IndexError as e:
		print("Wrong line") 

tgt = []
tgt_words = list(javalang.tokenizer.tokenize(tgt_line))
for word in tgt_words:
	tgt.append(word.value)

with open(pred_file, 'r') as f1:
	lines = f1.readlines()
	for line in lines[:2]:
		pred_words = line.strip().split()
		print(pred_words)
		for k,v in zip(tgt, pred_words):
			print(k,v)