import os
import sys
import datetime
import logging
import argparse
from collections import OrderedDict
from stanfordcorenlp import StanfordCoreNLP
from ufal.udpipe import Model, Pipeline, ProcessingError

"""
    Identify the gender of the subject in a sentence using UDPipe dependency tree.
"""

# Logging setting.
if not os.path.isdir('./logs'):
    os.mkdir('./logs')

logging_time = datetime.datetime.now()
logging.basicConfig(filename=f'./logs/single_identify_gender_{logging_time}.log', level=logging.DEBUG, filemode='w', format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')

# UDPipe Conf.

udpipe_models_path = '/home/aires/personal_work_troja/repos/udpipe/models'
udpipe_models = {'en': 'english-partut-ud-2.5-191206.udpipe',
                 'fr': 'french-gsd-ud-2.5-191206.udpipe',
                 'de': 'german-hdt-ud-2.5-191206.udpipe'}

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
    logging.debug(f'{line}')
    token_id = line_elems[0]
    token = line_elems[1]
    logging.debug(f'')
    sentence['tok_ids'][token_id] = {}

    for i, elem in enumerate(line_elems[1:]):
        sentence['tok_ids'][token_id][fields[i]] = elem


def get_text(sentence, init):

    next_ids = []

    for tok_id in sentence['tok_ids']:
        # Breadth.
        if sentence['tok_ids'][tok_id]['head'] == init:
            next_ids.append(tok_id)

    if not next_ids:
        return sentence['tok_ids'][init]['form']
    else:
        text = ''
        for next_id in next_ids:
            # Depth.
            text += get_text(sentence, next_id) + ' '

        return text + sentence['tok_ids'][init]['form']

    return False


def find_subject(sentence):

    subject_id = False

    for tok_id in sentence['tok_ids']:
        # Find tokens connected to the root.
        if 'subj' in sentence['tok_ids'][tok_id]['deprel']:
            subject_id = tok_id
            break

    if not subject_id:
        return False, False
    
    # Bring subject text.
    subject_text = get_text(sentence, subject_id)

    if not subject_text:
        return False, False

    logging.debug(f'Found subject! Subject ID: {subject_id}; Subject text: {subject_text}')

    return subject_id, subject_text


def write_to_file(out, sentence, gender=False):

    if gender:
        out_sent = f'{sentence}\t{gender}'
        logging.debug(f'Writing to {out} the following sentence: {out_sent}')
    else:
        logging.debug(f'Wrote to {out}: {sentence}')
        out_sent = sentence

    out.write(f'{out_sent}\n')
    out.flush()


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


def find_subject_gender(sentence):
    # Check if sentence has a subject and if there is a gender element associated to it.

    subj = ''

    for tok_id in sentence['tok_ids']:
        # Run over tokens.
        upostag = sentence['tok_ids'][tok_id]['upostag']

        if upostag == 'NOUN':
            deprel = sentence['tok_ids'][tok_id]['deprel']
            feats = sentence['tok_ids'][tok_id]['feats']
            if deprel == 'nsubj':
                if not subj:
                    subj = sentence['tok_ids'][tok_id]['form']
                    full_subj = get_text(sentence, tok_id)
                    logging.info(f'Found subject: {full_subj}')
                if 'Gender' in feats:
                    gender = feats.split('Gender')[1].split('|')[0][1:]
                    return gender

    return ''


def general_gender(sentence):

    gendered = list()

    # Look for nouns in sentence2.
    for tok_id in sentence['tok_ids']:

        token = sentence['tok_ids'][tok_id]['form']
        feats = sentence['tok_ids'][tok_id]['feats']
        deprel = sentence['tok_ids'][tok_id]['deprel']

        if sentence['tok_ids'][tok_id]['upostag'] == 'NOUN':
            
            # Check gender.
            if 'Gender' in feats:
                gender = feats.split('Gender')[1].split('|')[0][1:]
                found_gender = True
            else:
                continue
            
            gendered.append(f'{token}/{deprel}/{gender}')
        else:
            gendered.append(token)

    if found_gender:
        return ' '.join(gendered)
    else:
        return ''


def identify_gender(doc_path, lang, subject, model, out):

    doc = open(doc_path, 'r') 

    # Set output path.
    if not out:
        out = open(f'{doc_path}.gender', 'w')
    else:
        out = open(out, 'w')
    
    # Set UDPipe model.
    if not model:
        udp_model_path = os.path.join(udpipe_models_path, udpipe_models[lang])
    else:
        udp_model_path = model

    udp_model = Model.load(udp_model_path)
    
    # Set parser.
    parser = Pipeline(udp_model, 'horizontal', Pipeline.DEFAULT, Pipeline.DEFAULT, 'conllu')
    error = ProcessingError()

    logging.info(f'Working with {lang}')
    n_lines = 0

    while True:        
        # Run over doc.

        logging.info(f'Processing line: {n_lines}')
        n_lines += 1
        line = doc.readline()

        if line == '\n':
            continue
        elif not line:
            break
        else:
            line = line.strip()

        p_line = parser.process(line, error)
        
        sentence = process_file(p_line)
        
        if subject:
            gender = find_subject_gender(sentence)
            if gender:
                write_to_file(out, line, gender=gender)
        else:
            gendered = general_gender(sentence)
            # Here, gendered is a sentence.
            # I know, this is not ok.
            write_to_file(out, gendered)

    out.close()


if __name__ == "__main__":

    # Process arguments.
    parser = argparse.ArgumentParser(
            description='Identifies the gender of sentences from a single doc/language.')
    parser.add_argument('doc', type=str,
            help='Path to the doc to be processed. The language must be the same from lang.')
    parser.add_argument('lang', type=str, help='Language of document')
    parser.add_argument('subject', type=bool, default=False,
            help='Indicates  whether gender refers to subject only.')
    parser.add_argument('--model', type=str, default='',
            help='UDPipe model for lang.')
    parser.add_argument('--out', type=str, default='',
            help='Path to output the annotated data.')

    args = parser.parse_args()
    
    identify_gender(args.doc, args.lang, args.subject, args.model, args.out)
