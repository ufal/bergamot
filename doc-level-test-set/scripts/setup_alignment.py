import os
import sys
# import logging
import datetime
import argparse
from nltk.tokenize import moses


# Logging setting.
# if not os.path.isdir('./logs'):
#     os.mkdir('./logs')

# logging_time = datetime.datetime.now()
# logging.basicConfig(filename=f'./logs/prepare_data_{logging_time}.log', level=logging.DEBUG, filemode='w', format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')


def set_output(doc_path, lang1, lang2):
    # Take the base part of the file.
    base_path = '.'.join(doc_path.split('.')[:-1])
    return f'{base_path}.{lang1}-{lang2}'


def prepare_data(doc1, lang1, doc2, lang2, out):

    counter = 0

    # Setup tokenizers.
    tok1 = moses.MosesTokenizer(lang=lang1)
    tok2 = moses.MosesTokenizer(lang=lang2)

    while True:
        
        line1 = doc1.readline()
        line2 = doc2.readline()

        if line1 == '\n':
            continue
        elif line2 == '\n':
            continue
        elif not line1:
            # logging.debug(f"FINISHED: {counter}")
            break

        line1 = line1.rstrip()
        line2 = line2.rstrip()
        counter += 1

        # Tokenize sentneces.
        tok_line1 = ' '.join(tok1.tokenize(line1))

        tok_line2 = ' '.join(tok2.tokenize(line2))

        out.write(f'{tok_line1} ||| {tok_line2}\n')
        #out.write(f'{line1} ||| {line2}\n')
        out.flush()

    out.close()


def main(lang1, doc1_path, lang2, doc2_path, outpath=''):
    
    # logging.info(f'Processing files in {lang1} and {lang2}')

    # Open files.
    doc1 = open(doc1_path, 'r')
    doc2 = open(doc2_path, 'r')

    if not outpath:
        outpath = set_output(doc1_path, lang1, lang2)

    out = open(outpath, 'w')

    prepare_data(doc1, lang1, doc2, lang2, out)
    

if __name__ == "__main__":

    # Process arguments.
    parser = argparse.ArgumentParser(description='Prepare data for Fast Align.')
    parser.add_argument('lang1', type=str,
                    help='Language of doc1.')
    parser.add_argument('doc1', type=str,
                    help='Path to a file containing a sentence per line in lang1.')
    parser.add_argument('lang2', type=str,
                    help='Language of doc2')
    parser.add_argument('doc2', type=str,
                    help='Path to a file containing a sentence per line in lang2.')
    parser.add_argument('-o', '--output', type=str,
            default='', help="Path to the output file.")

    args = parser.parse_args()

    main(args.lang1, args.doc1, args.lang2, args.doc2, outpath=args.output)
