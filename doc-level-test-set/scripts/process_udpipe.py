import os
import sys
from collections import OrderedDict


def selector(line):
    # Select action to perform over line.
    # 0 - Initiate the structure of a new sentence.
    # 1 - Process token.
    # 2 - Next.

    if '# sent_id' in line:
        return 0
    elif line.split('\t')[0].isdigit():
        return 1
    else:
        return 2


def new_sentence(line):
    return int(line.split('=')[-1].strip())


def text_sentence(line):
    return line.split('=')[-1].strip()


def process_token(sentence, line):
    
    fields = ['form', 'lemma', 'upostag', 'xpostag', 'feats', 'head', 'deprel', 'deps', 'misc']
    line_elems = line.split('\t')
    token_id = line_elems[0]
    # token = line_elems[1]
    sentence['tok_ids'][token_id] = {}

    for i, elem in enumerate(line_elems[1:]):
        sentence['tok_ids'][token_id][fields[i]] = elem


def process_file(p_line):

    sentence = None 

    lines = p_line.split('\n')

    # Create structure.
    for line in lines:

        option = selector(line)

        if option == 0:
            sentence = {'tok_ids' : OrderedDict()}
            sentence['text'] = text_sentence(line)
            continue
        elif option == 1:
            process_token(sentence, line)
            continue
        elif option == 2:
            continue
        else:
            continue

    if not sentence:
        return False
    
    return sentence