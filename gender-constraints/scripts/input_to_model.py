import os
import sys
from mosestokenizer import MosesTokenizer

# Convert tab separated sentences into sentencepiece tokenization.
# Input: sentence\t gender
# Output: sentence<sep><gender>
# <gender> can be either <masc> or <fem>

# Indicate the input file's format. winomt or text.
#f_format = 'winomt'

# Set to True if you want sentences using <SEP> before gender tag.
separator = False

# Input and output by argument.
input_file = sys.argv[1]
output_file = sys.argv[2]
annotation = sys.argv[3]  # factors, subj, tags, inter, none
f_format = sys.argv[4]    # winomt, text

# Set accepted tags.
if annotation == 'subj':
    tags = {'male':'<masc>', 'female':'<fem>',
            'Fem':'<fem>', 'Masc':'<masc>'}
    if separator:
        sep = '<sep>'
    else:
        sep = ''
elif annotation == 'factors':
    tags = {'None': '0',
            'male': '1',
            'female': '2'
            }
elif annotation == 'tags':
    tags = {'male':'<masc>', 'female':'<fem>',
            'Fem':'<fem>', 'Masc':'<masc>'}
    actor = {'obj': '<obj>', 'subj':'<subj>'}
elif annotation == 'inter':
    tags = {'male':'<masc>', 'female':'<fem>',
            'Fem':'<fem>', 'Masc':'<masc>'}

single = False # 'female' # (female, or False)


# Write to file.
with open(output_file, 'w') as w_file:
    with open(input_file, 'r') as r_file:
        while True:
            line = r_file.readline()
            if line == '\n':
                continue
            if not line:
                break
            sent_tag = line.split('\t')
            
            if f_format == 'winomt':
                gender, index, sent, _ = sent_tag
                
                # TODO: Add the other annotations as an option for this.
                if annotation == 'factors':
                    index = int(index)
                    with MosesTokenizer('en') as tokenize:
                        tok_sent = tokenize(sent)

                    final_sent = ''
                    for ind, token in enumerate(tok_sent):
                        if ind == index and gender != 'neutral':
                            final_sent =  final_sent + ' ' + token + tags[gender]
                        else:
                            final_sent = final_sent + ' ' + token + tags['None']
                    w_file.write(final_sent  + '\n')

                elif annotation == 'none':
                    w_file.write(sent + '\n')

            elif f_format == 'text':
                if annotation == 'factors':
                    with MosesTokenizer('en') as tokenize:
                        tok_sent = tokenize(line.strip())

                    final_sent = ''
                    for token in tok_sent:
                        final_sent = final_sent + ' ' + token + tags['None']
                    w_file.write(final_sent  + '\n')
                elif annotation == 'tags':
                    # TODO: Fix this option for all annotation types.
                    if len(sent_tag) == 2 and not single:
                        sent = sent_tag[0]
                        tag = sent_tag[1]
                        tag = tag.strip()
                        if tag.strip() in tags:
                            w_file.write(f'{sent}{sep}{tags[tag]}\n')
                    else:
                        if single:
                            line = line.strip()
                            w_file.write(f'{line}{sep}{tags[single]}\n')
                        else:
                            w_file.write(f'{line}')
