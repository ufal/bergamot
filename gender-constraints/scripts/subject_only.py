import os
import re
import sys
import argparse
from mosestokenizer import *


def remove_annotation(line, detok):

    ann_pattern = re.compile(r'\/[a-z\:]+\/[A-Z][a-z]+')

    tokens = line.split()
    new_line = ''

    for token in tokens:

        match = ann_pattern.search(token)

        if match:
            new_token = token[:match.span()[0]]
        else:
            new_token = token

        new_line += new_token + ' '

    # Detokenize.
    new_line = detok(new_line.split())

    return new_line


def main(dataset, lang, out=''):

    # Read document.
    doc = open(dataset, 'r')

    # Set output.
    if not out:
        out = open(f'{dataset}.subject', 'w')
    else:
        out = open(out, 'w')

    # Set moses detokenizer.
    detok = MosesDetokenizer(lang)

    while True:
        line = doc.readline()

        if not line:
            break

        # List by spaces.
        tokens = line.split()
        gender = ''
        # Run over tokens.
        for token in tokens:
            # Extract subject part.
            if 'subj' in token:
                #print(token)
                gender = token.split('/')[-1]
		break

        clean_line = remove_annotation(line, detok)

        # Save to file.
        if gender:
            out.write(f'{clean_line}\t{gender}\n')

    doc.close()
    detok.close()


if __name__ == '__main__':

    # Process arguments.
    parser = argparse.ArgumentParser(description='Convert a multi-annotated file into a subject-centered gender file.')
    parser.add_argument('doc', type=str,
                    help='Path to the file to be converted.')
    parser.add_argument('lang', type=str,
                    help='Language of doc.')
    parser.add_argument('--out', type=str, default='',
                    help='Output path to the converted document.')

    args = parser.parse_args()

    main(args.doc, args.lang, out=args.out)
