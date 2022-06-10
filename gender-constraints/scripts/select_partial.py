import os
import sys
import copy
import argparse

from process_annotation import check_token

"""
    Create training data using data augmentation techniques.
    Given a file containing annotations from UDPipe, generate multiple inputs for the same sentences by partially adding gender annotation to the input.
"""


def partial_order(p_sents, r_sent):
    
    part_sents = []

    for ind, text in p_sents:
        c_sent = copy.deepcopy(r_sent)
        c_sent[ind] = text
        part_sents.append(' '.join(c_sent))

    return part_sents


def process_line(s_line: str, r_line: str, m_dict: dict) -> tuple:
    
    ss_line = s_line.split()
    raw_sent = list()
    full_sent = ''
    partial_sents = []
    out_src = []
    out_ref = []

    for ind, token in enumerate(ss_line):
        tok_dict = check_token(token) # token, deprel, gender
        if 'None' in m_dict:
            raw_sent.append(tok_dict['token'] + m_dict['None'])
        else:
            raw_sent.append(tok_dict['token'])
        if tok_dict['gender']:
            full_sent = full_sent + ' ' + tok_dict['token'] + m_dict[tok_dict['gender']]
            partial_sents.append((ind, tok_dict['token']+m_dict[tok_dict['gender']]))
        else:
            if 'None' in m_dict:
                full_sent = full_sent + ' ' + tok_dict['token'] + m_dict['None']
            else:
                full_sent = full_sent + ' ' + tok_dict['token']
    
    # Add raw and full sents to the list of sentences.
    out_src.append(full_sent)
    out_ref.append(r_line)
    out_src.append(' '.join(raw_sent))
    out_ref.append(r_line)
    # Process partial sents.
    part_sents = partial_order(partial_sents, raw_sent)
    for sent in part_sents:
        out_src.append(sent)
        out_ref.append(r_line)

    return out_src, out_ref


def process_file(source_path: str, ref_path: str, mode:str, out_path='') -> None:
    
    if not out_path:
        out_s_path = source_path + '_' + mode + '.src'
        out_r_path = ref_path + '_' + mode + '.tgt'

    ann_dict = dict()
    # Set dict.
    if mode == 'factors':
        ann_dict = {'None': '0',
                    'Masc': '1',
                    'Fem' : '2' }        
    elif mode == 'tags':
        ann_dict = {'Masc': '<masc>',
                    'Fem': '<fem>'
                    }
    else:
        print(f'Not a valid mode: {mode}')

    with open(source_path, 'r') as s_file, open(ref_path, 'r') as r_file, open(out_s_path, 'w') as s_write, open(out_r_path, 'w') as r_write:
        while True:
            s_line = s_file.readline()
            r_line = r_file.readline()

            if not s_line or not r_line:
                break

            # Process line.
            out_src, out_ref = process_line(s_line, r_line, ann_dict) 
            
            for i in range(len(out_src)):
                s_write.write(out_src[i] + '\n')
                r_write.write(out_ref[i])
                s_write.flush()
                r_write.flush()


if __name__ == '__main__':

    # Process arguments.
    parser = argparse.ArgumentParser(description='Process parallel data.')
    parser.add_argument('source_path', type=str,
                    help='Path to file containing gender annotation.')
    parser.add_argument('ref_path', type=str,
                    help='Path to file containing reference to source_path.')
    parser.add_argument('mode', type=str,
                    help='tags or factors')
    parser.add_argument('--out', type=str, default='',
                    help='path to place the output files')

    args = parser.parse_args()

    process_file(args.source_path, args.ref_path, args.mode, out_path=args.out)
