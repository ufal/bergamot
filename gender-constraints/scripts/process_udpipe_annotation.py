import os
import sys
#from mosestokenizer import *

"""
    Receive a file containing UDPipe annotation along with each token.
    The annotation contains both the dependency relation and the gender associated. E.g.: The student/nsubj/Fem called the teacher/obl/Masc .
    Convert UDPipe annotation according to one of the pre-defined formats: factors, factors_dup, tags, etc.
"""


TOKENIZE=False

if TOKENIZE:
    from mosestokenizer import *


def read_file(path):

    with open(path, 'r') as r_file:
        while True:
            line = r_file.readline()
            if not line:
                break
            yield line
    

def check_token(token):
    tok_dic = {'token': '', 'deprel': '', 'gender': ''}
    elems = token.split('/')
    if len(elems) == 3:
        tok_dic['token'] = elems[0]
        tok_dic['deprel'] = elems[1].split(':')[0]        
        tok_dic['gender'] = elems[2]
    else:
        tok_dic['token'] = token

    return tok_dic


def gen_factor_sent(sent, factor):

    factor_sent = ''

    for token in sent:
        tok_dic = check_token(token)
        add_tok = tok_dic['token']
        factor_sent = f"{factor_sent} {add_tok}{factor}"

    return factor_sent


def gen_tag_sent(sent):

    tag_sent = ''

    for token in sent:
        tok_dic = check_token(token)
        add_tok = tok_dic['token']
        tag_sent = f"{tag_sent} {add_tok}"
    
    return tag_sent


def tags_duplicate(s_path, r_path, tokenize=False):
    # Annotation.
    gender = {'Masc': '<masc>', 'Fem': '<fem>'}

    file_tail = '.tags_dup' 
    s_out = s_path + file_tail
    r_out = r_path + file_tail
    print(f"Creating {s_out} and {r_out}")

    with open(s_out, 'w') as sw_out, open(r_out, 'w') as rw_out:
        with open(s_path, 'r') as s_read, open(r_path, 'r') as r_read:

            while True:
                s_line = s_read.readline()
                r_line = r_read.readline()
                
                if not s_line:
                    break

                if tokenize:
                    # Tokenize.
                    with MosesTokenizer('en') as tok:
                        sent = tok(s_line)
                else:
                    sent = s_line.split()

                raw_sent = gen_tag_sent(sent)
                
                duplicate = False
                out_sent = ''
                
                for token in sent:
                    tok_dic = check_token(token)
                    if tok_dic['gender']:
                        if not duplicate:
                            duplicate = True
                            sw_out.write(raw_sent + '\n')
                            rw_out.write(r_line)
                        if tok_dic['gender'] == 'Masc':
                            add_tok = tok_dic['token']
                            out_sent = f'{out_sent} {add_tok}{gender["Masc"]}'
                        elif tok_dic['gender'] == 'Fem':
                            add_tok = tok_dic['token']
                            out_sent = f'{out_sent} {add_tok}{gender["Fem"]}'
                    else:
                        add_tok = tok_dic['token']
                        out_sent = f'{out_sent} {add_tok}'
                sw_out.write(out_sent + '\n')
                rw_out.write(r_line)
                sw_out.flush()
                rw_out.flush()


def factors_duplicate(s_path, r_path, tokenize=False):
    # Annotation.
    no_gender = '0'
    masc = '1'
    fem= '2'
    
    file_tail = '.factors_dup' 
    s_out = s_path + file_tail
    r_out = r_path + file_tail
    print(f"Creating {s_out} and {r_out}")

    with open(s_out, 'w') as sw_out, open(r_out, 'w') as rw_out:
        with open(s_path, 'r') as s_read, open(r_path, 'r') as r_read:

            while True:
                s_line = s_read.readline()
                r_line = r_read.readline()
                
                if not s_line:
                    break

                if tokenize:
                    # Tokenize.
                    with MosesTokenizer('en') as tok:
                        sent = tok(s_line)
                else:
                    sent = s_line.split()

                zero_sent = gen_factor_sent(sent, no_gender)
                out_sent = ''
                duplicate = False
                for i, token in enumerate(sent):
                    tok_dic = check_token(token)
                    if tok_dic['gender']:
                        if not duplicate:
                            duplicate = True
                            sw_out.write(zero_sent + '\n')
                            rw_out.write(r_line)
                        if tok_dic['gender'] == 'Masc':
                            add_tok = tok_dic['token']
                            out_sent = f'{out_sent} {add_tok}{masc}'
                        elif tok_dic['gender'] == 'Fem':
                            add_tok = tok_dic['token']
                            out_sent = f'{out_sent} {add_tok}{fem}'
                    else:
                        add_tok = tok_dic['token']
                        out_sent = f'{out_sent} {add_tok}{no_gender}'

                sw_out.write(out_sent + '\n')
                rw_out.write(r_line)
                sw_out.flush()
                rw_out.flush()


def factors(f_path, tokenize=False, duplicate=False):
    # Convert sentences into factor annotation.
    # Annotation.
    no_gender = '0'
    masc = '1'
    fem= '2'
    
    out = f_path + '.factors'
    print(f"Creating {out}")

    with open(out, 'w') as w_out:
        for sent in read_file(f_path):
            out_sent = ''
            if tokenize:
                # Tokenize.
                with MosesTokenizer('en') as tok:
                    sent = tok(sent)
            else:
                sent = sent.split()
            for token in sent:
                tok_dic = check_token(token)
                if tok_dic['gender']:
                    if tok_dic['gender'] == 'Masc':
                        out_sent = out_sent + tok_dic['token'] + masc + ' '
                        continue
                    elif tok_dic['gender'] == 'Fem':
                        out_sent = out_sent + tok_dic['token'] + fem + ' '
                        continue
                out_sent = out_sent + tok_dic['token'] + no_gender + ' '
            w_out.write(out_sent[:-1] + '\n')


def factors_subjobj(f_path, tokenize=False, duplicate=False):
    # Convert sentences into factor annotation.
    # Annotation.
    no_gender = '0'
    masc = '1'
    fem= '2'
    
    out = f_path + '.factors_subjobj'
    print(f"Creating {out}")

    with open(out, 'w') as w_out:
        for sent in read_file(f_path):
            out_sent = ''
            if tokenize:
                # Tokenize.
                with MosesTokenizer('en') as tok:
                    sent = tok(sent)
            else:
                sent = sent.split()

            for token in sent:
                tok_dic = check_token(token)
                if 'nsubj' in tok_dic['deprel'] or 'obl' in tok_dic['deprel']:
                    if tok_dic['gender']:
                        if tok_dic['gender'] == 'Masc':
                            out_sent = out_sent + tok_dic['token'] + masc + ' '
                            continue
                        elif tok_dic['gender'] == 'Fem':
                            out_sent = out_sent + tok_dic['token'] + fem + ' '
                            continue
                out_sent = out_sent + tok_dic['token'] + no_gender + ' '
            w_out.write(out_sent[:-1] + '\n')


def factors_subj(f_path, tokenize=False, duplicate=False):
    # Convert sentences into factor annotation.
    # Annotation.
    no_gender = '0'
    masc = '1'
    fem= '2'
    
    out = f_path + '.factors_subj'
    print(f"Creating {out}")

    with open(out, 'w') as w_out:
        for sent in read_file(f_path):
            out_sent = ''
            if tokenize:
                # Tokenize.
                with MosesTokenizer('en') as tok:
                    sent = tok(sent)
            else:
                sent = sent.split()
            g_flag = False

            for token in sent:
                tok_dic = check_token(token)
                if 'nsubj' in tok_dic['deprel'] and not g_flag:
                    if tok_dic['gender']:
                        if tok_dic['gender'] == 'Masc':
                            out_sent = out_sent + tok_dic['token'] + masc + ' '
                            g_flag = True
                            continue
                        elif tok_dic['gender'] == 'Fem':
                            out_sent = out_sent + tok_dic['token'] + fem + ' '
                            g_flag = True
                            continue
                out_sent = out_sent + tok_dic['token'] + no_gender + ' '
            w_out.write(out_sent[:-1] + '\n')


def tags(f_path, tokenize=False, tok_annotation=False, duplicate=False):
    # Add tags to subject and object in the end of the sentence.
    # Annotation.
    print('Started processing tags.')
    
    subj = '<subj>'
    obj = '<obj>'
    gender = {'Masc': '<masc>', 'Fem': '<fem>'}
    # Accepted deprel annotations.
    deprel = {'nsubj': '<subj>', 'obl': '<obj>'}

    out = f_path + '.tags'

    with open(out, 'w') as w_out:
        for sent in read_file(f_path):
            out_sent = ''
            final_tags = ''
            subj = False
            obj = False
            if tokenize:
                # Tokenize.
                with MosesTokenizer('en') as tok:
                    sent = tok(sent)
            else:
                sent = sent.split()
            for token in sent:
                tok_dic = check_token(token)
                # Add token.
                out_sent = out_sent + tok_dic['token'] + ' '
                # Check subj annotation.
                if not subj:
                    if 'nsubj' in tok_dic['deprel']:
                        final_tags = final_tags + deprel['nsubj'] + gender[tok_dic['gender']]
                        subj = True
                if not obj:
                    if 'obl' in tok_dic['deprel']:
                        final_tags = final_tags + deprel['obl'] + gender[tok_dic['gender']]
                        obj = True
            out_sent = out_sent[:-1] + final_tags
            w_out.write(out_sent + '\n')

if __name__ == "__main__":

    # User input (path_to_file, mode (factors, tag)).
    mode = sys.argv[1]
    path_to_src = sys.argv[2]

    if 'duplicate' in mode:
        path_to_ref = sys.argv[3]


    print(f'Processing file: {path_to_src}\nAnnotation: {mode}')
    if 'duplicate' in mode:
        eval(mode)(path_to_src, path_to_ref, tokenize=TOKENIZE)
    eval(mode)(path_to_src, tokenize=TOKENIZE)
