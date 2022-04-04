import os
import sys
import random

"""Replace people's names with gender neutral names."""

# Test on: guardian.306616.ner

# Gender Neutral doc Path.
neutral_names = '/home/aires/personal_work_troja/style_transfer/doc_gender/data/gender_neutral_names.txt'

# Input file.
in_file = sys.argv[1]

# Set output file.
out_file = f'{in_file}.nn'

# Read neutral names.
n_names = [x.strip() for x in open(neutral_names, 'r').readlines()]

ch_names = dict()

with open(in_file, 'r') as r_file, open(out_file, 'w') as w_file:

    while True:

        line = r_file.readline()

        if not line:
            break

        # Find tags.
        line = line.strip()
        s_line = line.split('\t')
        ls_line = len(s_line)

        if ls_line < 2:
            sent = line
        else:
            sent = s_line[0]
            tags = s_line[1]

            if tags == '\n':
                continue
    
            # Manipulatei tags.
            t = tags.split('/')
            lt = len(t)
            if lt == 2:
                tags = [f'{t[0]}/{t[1]}']
            else:
                tags = [f"{t[0]}/{t[1].split(' ')[0]}"]+[f"{' '.join(t[x].split(' ')[1:])}/{t[x+1].split(' ')[0]}" for x in range(1, len(t) - 1)]
            
            for tag in tags:
                ent, ne = tag.split('/')
    
                if ne == 'PERSON':
                    if ent not in ch_names:
                        ent_key = ''

                        for key in ch_names:
                            if ent in key or key in ent:
                                ent_key = key
                        if ent_key:
                            ch_names[ent] = ch_names[ent_key]
                        else:
                            ch_names[ent] = random.choice(n_names)
            
                    # Modify the name in the text.
                    finished = False
                    while not finished:
                        ind = sent.find(ent)

                        if ind == -1:
                            finished = True
                        else:
                            sent = f'{sent[:ind]} {ch_names[ent]} {sent[ind+len(ent):]}'
        
        w_file.write(f'{sent}\n')

