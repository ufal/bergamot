import os
import re
import sys
import argparse
import pandas as pd


"""
    Convert gender dataset into a dataset for training a gender classifier.
"""

# General paths.
de_en = '/home/aires/personal_work_troja/style_transfer/data/gender/de-en'
fr_en = '/home/aires/personal_work_troja/style_transfer/data/gender/fr-en'
all_pairs = ['de_en', 'fr_en']


def process_pair(lang_pair):
    
    if lang_pair.startswith('de'):
        src, trg = lang_pair.split('_')
        base_path = de_en
    elif lang_pair.startswith('fr'):
        src, trg = lang_pair.split('_')
        base_path = fr_en
    elif lang_pair.startswith('all'):
        result = []

        for pair in all_pairs:
            tup = process_pair(pair)
            result.append(tup)

        return result

    else:
        print(f'{lang_pair} is not a valid option.')
        sys.exit(1)

    source = f'europarl.{src}-{trg}.{src}.aligned.tok'
    source = os.path.join(base_path, source)
    target = f'europarl.{src}-{trg}.{trg}.aligned.tok'
    target = os.path.join(base_path, target)

    ref = f'europarl.{src}-{trg}.dat'
    ref = os.path.join(base_path, ref)

    return (source, target, ref)


def read_files(src, trg, ref, out_path):

    gender_finder = r'GENDER=\"[A-M]+?\"'
    age_finder = r'AGE=\"[0-9]+?\"'

    reference = open(ref, 'r')

    source = open(src, 'r')
    src_lang = src.split('-')[0].split('.')[-1]
    if out_path:
        src_out = os.path.join(out_path, f'{src_lang}.csv')
    src_sents = []
    gender_col = []
    age_col = []

    target = open(trg, 'r')
    trg_sents = []
    trg_lang = trg.split('-')[-1].split('.')[0]

    if out_path:
        trg_out = os.path.join(out_path, f'{src_lang}-{trg_lang}.csv')

    print(f"Saving source file in: {src_out}\nSaving target file in: {trg_out}")

    # For each sentence in reference.
    while True:
        # Read line.
        ref_line = reference.readline()

        if not ref_line:
            break 

        src_line = source.readline()
        src_sents.append(src_line.strip())

        trg_line = target.readline()
        trg_sents.append(trg_line.strip())

        if not src_line or not trg_line:
            break

        # Find gender.
        g_info = re.findall(gender_finder, ref_line)[0]
        gender = g_info.split('"')[1]
        gender_col.append(gender)

        # Find age.
        a_info = re.findall(age_finder, ref_line)[0]
        age = int(a_info.split('"')[1])
        age_col.append(age)

    print(f"Sizes:\n\tsource:{len(src_sents)}\n\ttarget:{len(trg_sents)}\n\tage:{len(age_col)}\n\tgender:{len(gender_col)}")

    src_dict = {'sent':src_sents, 'gender':gender_col, 'age':age_col}
    src_df = pd.DataFrame(src_dict)
    src_df.to_csv(src_out)

    trg_dict = {'sent':trg_sents, 'gender':gender_col, 'age':age_col}
    trg_df = pd.DataFrame(trg_dict)
    trg_df.to_csv(trg_out)


# de-en, fr-en, all.
def process_lang_pair(lang_pair, out_path=''):

    print(f"Processing {lang_pair}")
    paths = process_pair(lang_pair)

    if type(paths) == tuple:
        src, trg, ref = paths
        read_files(src, trg, ref, out_path)
    
    elif type(paths) == list:
        for path in paths:
            print(f"Processing {path}")
            if type (path) == tuple:
                src, trg, ref = path
                read_files(src, trg, ref, out_path)
    else:
        print(f'{type(paths)} is not one of the accepted types.')
        sys.exit(1)


if __name__ == "__main__":
    # Process arguments.
    parser = argparse.ArgumentParser(description='Process parallel data.')
    parser.add_argument('lang_pair', type=str,
                    help='de_en, fr_en, all')
    parser.add_argument('--out', type=str, default='',
                    help='path to place the output files')


    args = parser.parse_args()

    process_lang_pair(args.lang_pair, out_path=args.out)
