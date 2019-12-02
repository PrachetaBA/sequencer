import os
import pprint 

all_proj = os.listdir('Defects4J_patches')

accuracy = {}

for p in all_proj:
	path = 'Defects4J_patches/'+p+'/'+p+'.txt'
	project = p.split('_')[0] + '_' + p.split('_')[1]
	with open(path, 'r') as f:
		acc = f.read().rstrip('\n')
		accuracy[project] = acc

pp = pprint.PrettyPrinter(indent=4)
pp.pprint(accuracy)