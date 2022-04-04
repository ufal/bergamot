import os
import sys

import spacy

spacy_models = {'en': "en_core_web_sm"}

in_folder = sys.argv[1]
lang = sys.argv[2] # (en or cs)

NER = spacy.load(spacy_models[lang])

# Run over files.
fs = os.listdir(in_folder)

forb_ext = ['ner', 'all', 'previous', 'cs']

for f in fs:
    
    file_path = os.path.join(in_folder, f)
    
    print(f'File: {file_path}')

    # Check if it is a folder.
    if os.path.isdir(file_path):
        continue

    if f.split('.')[-1] in forb_ext:
        continue    
    
    out_path = os.path.join(in_folder, 'ner')
    out_file_name = f'{f}.ner'
    out_path = os.path.join(out_path, out_file_name)

    print(out_path)
    # Create an annotated file.
    with open(file_path, 'r') as r_file, open(out_path, 'w') as w_file:
        # Read file.
        while True:
            line = r_file.readline()

            if not line:
                break

            # Process with spacy.
            ner_line = NER(line)

            out_ann = ''
            
            line = line.strip()

            for word in ner_line.ents:
                out_ann = f'{out_ann}\t{word.text}/{word.label_}' 
                # w_file.write(f'{word.text}/{word.label_} ')
            w_file.write(f'{line}\t{out_ann}\n')
