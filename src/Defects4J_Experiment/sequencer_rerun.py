import pandas as pd 
import os

files = os.listdir('Defects4J_projects')

orig_df = pd.read_csv('sequencer_metadata.csv',names=['Project','Version','File','Line'])

new_df = pd.DataFrame(columns=['Project','Version','File','Line'])

for file in files:
	line = file.split('_')
	project = line[0]
	version = int(line[1])
	buggy_line = int(line[2])
	
	bug = orig_df.loc[(orig_df['Project'] == project) & (orig_df['Version']==version) & (orig_df['Line']==buggy_line)]
	
	new_df = new_df.append(bug)

new_df.to_csv('sequencer_rerun.csv',index=False, header=False)

