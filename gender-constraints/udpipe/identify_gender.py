import os
import sys
import datetime
import logging
import argparse
from collections import OrderedDict
from ufal.udpipe import Model, Pipeline, ProcessingError
from identify_gender_single_lang import find_subject_gender

"""
    Identify the gender in the sentence using UDPipe dependency tree.
"""

# Logging setting.
if not os.path.isdir('./logs'):
    os.mkdir('./logs')

logging_time = datetime.datetime.now()
logging.basicConfig(filename=f'./logs/identify_gender_{logging_time}.log', level=logging.DEBUG, filemode='w', format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')

# UDPipe Conf.
udpipe_models_path = '/home/aires/personal_work_troja/repos/udpipe/models'
# Add models here if you want to work with other languages.
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


def look_for_gender(sentence, subject_id, subject_text):
   
    logging.debug(f'Subject Text: {subject_text}')

    for tok_id in sentence['tok_ids']:

        if 'Gender' in sentence['tok_ids'][tok_id]['feats']:
            token_deprel = sentence['tok_ids'][tok_id]['deprel']
            subj_deprel = sentence['tok_ids'][subject_id]['deprel'] 
            if token_deprel == subj_deprel:
                # Get gender information.
                gender = sentence['tok_ids'][tok_id]['feats'].split('Gender')[1].split('|')[0][1:]
                logging.info(f'Found gender! {gender}')
                return gender
    return False


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


def find_gender(p_line1, p_line2, a_line):

    # Convert the UDPipe output into a dictionary.
    sentence1 = process_file(p_line1)
    sentence2 = process_file(p_line2)

    # List to store the gender for each token in sentenceN.
    gender1 = list()
    gender2 = list()

    ialign = dict()
    ialign = {key: value for value, key in [kv.split('-') for kv in a_line.split()]}

    found_gender = False

    to_en = {}

    # Look for nouns in sentence2.
    for tok_id in sentence2['tok_ids']:

        token = sentence2['tok_ids'][tok_id]['form']
        upostag = sentence2['tok_ids'][tok_id]['upostag']
        feats = sentence2['tok_ids'][tok_id]['feats']

        if upostag == 'NOUN':
            # Check gender.
            if 'Gender' in feats:
                gender = feats.split('Gender')[1].split('|')[0][1:]
                deprel = sentence2['tok_ids'][tok_id]['deprel']
                found_gender = True
            else:
                continue
            
            # Look for the same term in sentence1.
            a_tok_id = str(int(tok_id) - 1) # Alignment counts from 0, tok_id counts from 1.
            if a_tok_id not in ialign:
                continue
            sent1_tok_id = str(int(ialign[a_tok_id])+1)
            to_en[sent1_tok_id] = {'deprel': deprel, 'gender': gender}

            gender2.append(f'{token}/{deprel}/{gender}')
        else:
            gender2.append(token)

#    if not found_gender:
#        return False, False

    for tok_id in sentence1['tok_ids']:

        token = sentence1['tok_ids'][tok_id]['form']
        feats = sentence1['tok_ids'][tok_id]['feats']
        # Take the gender, if it exists.
        if 'Gender' in feats:
            gender_source = feats.split('Gender')[1].split('|')[0][1:]
        else:
            gender_source = ''

        if tok_id in to_en:
            deprel = to_en[tok_id]['deprel']
            gender = to_en[tok_id]['gender']
            if gender == gender_source or not gender_source:
                gender1.append(f'{token}/{deprel}/{gender}')
            else:
                gender1.append(token)
#                return False, False
#                    gender1.append(f'{token}/{deprel}/{gender_source}')
        else:
            gender1.append(token)

    return gender1, gender2


def identify_gender(lang1, lang2, subject='', aligned='', a_file='',
            doc1_path='', doc2_path='', out='', mixed=True):
    print(lang1, lang2, subject, aligned, a_file, doc1_path, doc2_path, out, mixed)
    # Set UDPipe models and Parsers.
    # If you want to change models, just modify the udpipe_models variable.
    udp_model1_path = os.path.join(udpipe_models_path, udpipe_models[lang1])
    udp_model2_path = os.path.join(udpipe_models_path, udpipe_models[lang2])
    print(udp_model1_path)
    print(udp_model2_path)

    udp_model1 = Model.load(udp_model1_path)
    udp_model2 = Model.load(udp_model2_path)

    parser1 = Pipeline(udp_model1, 'horizontal', Pipeline.DEFAULT, Pipeline.DEFAULT, 'conllu')
    parser2 = Pipeline(udp_model2, 'horizontal', Pipeline.DEFAULT, Pipeline.DEFAULT, 'conllu')
    
    error = ProcessingError()

    if subject:
        print("Processing annotation while focusing on subject.")
        # Read docs.
        doc1 = open(doc1_path, 'r')
        doc2 = open(doc2_path, 'r')

        # Set output files.
        if not out:
            if mixed:
                out1 = open(f'{doc1_path}.mixed', 'w')
                out2 = open(f'{doc2_path}.mixed', 'w')
                diff_out = open(f'{doc1_path[:-2]}.mixed.diff', 'w')
            else:
                out1 = open(f'{doc1_path}.gender', 'w')
                out2 = open(f'{doc2_path}.gender', 'w')
                diff_out = open(f'{doc1_path[:-2]}.diff', 'w')
        else:
            if mixed:
                out1 = open(f'{out}_{lang1}.mixed', 'w')
                out2 = open(f'{out}_{lang2}.mixed', 'w')
                diff_out = open(f'{out}.mixed.diff', 'w')
            else:
                out1 = open(f'{out}_{lang1}.gender', 'w')
                out2 = open(f'{out}_{lang2}.gender', 'w')
                diff_out = open(f'{out}.diff', 'w')

        logging.info(f'Working with {lang1} and {lang2}.')

        n_lines = 0

        # Run through documents lines.
        while True:
            
            # Read lines.
            line1 = doc1.readline()
            line2 = doc2.readline()

            # Check lines.
            if line1 == '\n':
                continue
            elif line2 == '\n':
                continue
            elif not line1:
                break
            else:
                line1 = line1.strip()
                line2 = line2.strip()

            # Parse lines.
            p_line1 = parser1.process(line1, error)
            p_line2 = parser2.process(line2, error)

            # Create a dict structure to the parsing.
            sentence1 = process_file(p_line1)
            sentence2 = process_file(p_line2)

            # Find the subject of each sentence.
            gender1 = find_subject_gender(sentence1)
            gender2 = find_subject_gender(sentence2)

            print(gender1, gender2)
            if not gender2:
                if not mixed:
                    continue
                else:
                    write_to_file(out1, line1)
                    write_to_file(out2, line2)

            # Check if genders agree.
            if gender1 == gender2 and gender1:
                write_to_file(out1, line1, gender=gender1)
                write_to_file(out2, line2, gender=gender2)
            else:

                if not gender1:
                    if lang1 == 'en':
                        # If no gender found in the English side, consider the gender in lang2.
                        if gender2:
                            write_to_file(out1, line1, gender=gender2)
                            write_to_file(out2, line2, gender=gender2)
                elif not gender2:
                    if lang2 == 'en':
                        if gender1:
                            write_to_file(out1, line1, gender=gender1)
                            write_to_file(out2, line2, gender=gender1)
                else:
                    # Save the difference to diff file.
                    diff_out.write(f'{line1}\t{line2}\t{gender1}/{gender2}\n')
                    if mixed:
                        write_to_file(out1, line1)
                        write_to_file(out2, line2)
    
    else:
        
        print("processing aligned file.")

        # Read files.
        aligned = open(aligned, 'r')
        aligned_file = open(a_file, 'r')

        # Set output files.
        if not out:
            out1 = open(f'{aligned}_{lang1}.gender', 'w')
            out2 = open(f'{aligned}_{lang2}.gender', 'w')
            diff_out = open(f'{aligned}.diff', 'w')
        else:
            out1 = open(f'{out}_{lang1}.gender', 'w')
            out2 = open(f'{out}_{lang2}.gender', 'w')
            diff_out = open(f'{out}.diff', 'w')
        # Not using diff_out yet, I have to think about how.

        logging.info(f'Working with {lang1} and {lang2}.')

        n_lines = 0

        while True:
            
            logging.info(f'Processing line: {n_lines}')
            n_lines += 1

            line = aligned.readline()

            if not line:
                break

            line1, line2 = line.split(' ||| ')
            a_line = aligned_file.readline()

            line1 = line1.strip()
            line2 = line2.strip()

            p_line1 = parser1.process(line1, error)
            p_line2 = parser2.process(line2, error)

            # Assuming parallel data
            gender1, gender2 = find_gender(p_line1, p_line2, a_line)

            if not gender1:
                logging.debug(f"Couldn't find gender for: {line1}")
                print('gender1')
                print(p_line1)
                continue

            if not gender2:
                logging.debug(f"Couldn't find gender for: {line2}")
                print('gender2')
                print(p_line2)

                continue

#            logging.info(f'Found {gender1} for line1 and {gender2} for line2.')
            write_to_file(out1, ' '.join(gender1))
            write_to_file(out2, ' '.join(gender2))
    out1.close()
    out2.close()
    diff_out.close()


def check_args(args):

    print("Checking arguments.")

    assert args.lang1 != args.lang2, "Languages must be different."

    assert args.lang1 in udpipe_models, f"{args.lang1} not a valid language."
    assert args.lang2 in udpipe_models, f"{args.lang2} not a valid language."

    if args.aligned:
        print("Using aligned option: ", args.aligned)
        if not args.aligned_file:
            print("An alignment between languages must have an aligned file.")
            sys.exit(1)
        if args.doc1 or args.doc2:
            print("When using the alignment input, you must not provide a separated document.")
            sys.exit(1)
    #    if args.subject:
    #        print("We use the alignment for a general gender annotation. Thus, do not set the subject parameter to True.")
    #        sys.exit(1)

    if not args.aligned:
        if not args.subject:
            print("When you don't provide an alginment document, subject must be True.")
            sys.exit(1)

        if args.aligned_file:
            print("If you do not provide an alignment file, you should not pass an aligned file as argument.")
            sys.exit(1)


if __name__ == "__main__":

    # Process arguments.

    parser = argparse.ArgumentParser(description='Identifies the gender in parallel data.')
    parser.add_argument('lang1', type=str,
                    help='Language of doc1/left side of the alignment file.')
    parser.add_argument('lang2', type=str,
                    help='Language of doc2/right side of the alignment file.')
    parser.add_argument('-s', '--subject', type=bool, default=False,
                    help='If True, gender is centered on the subject.')
    parser.add_argument('-a', '--aligned', type=str, default='',
                    help='Path to an aligned document between lang1 and lang2.')
    # This option refers to the input document to Fast Align.
    # It has a ||| separation between sentences from lang1 and lang2.
    parser.add_argument('-af', '--aligned_file', type=str, default='',
                    help='Path to file contining the alignment of tokens in aligned.')
    parser.add_argument('-d1', '--doc1', type=str, default='',
                    help='Path to the document containing sentences in lang1.')
    parser.add_argument('-d2', '--doc2', type=str, default='',
                    help='Path to the document containing sentences in lang2.')
    parser.add_argument('--out', type=str, default='',
                    help='Path to the output file with a base name. E.g.: /path/to/doc the outpus can be /path/to/doc.gender if alignment, or /path/to/doc_lang1.gender and /path/to/doc_lang2.gender if subject.')

    args = parser.parse_args()

    check_args(args)

    identify_gender(args.lang1, args.lang2, subject=args.subject,
            aligned=args.aligned, a_file=args.aligned_file,
            doc1_path=args.doc1, doc2_path=args.doc2, out=args.out)
