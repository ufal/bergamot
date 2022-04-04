from __future__ import annotations
import os
import re
import sys
import pickle

person_names_path = "../data/wmt21/test-src/en-cs/ner/person_names.pkl"
pronouns_path = "../data/english_pronouns.txt"


def process_files(folder_path: str) -> list:
    
    # Read folder.
    files = os.listdir(folder_path)

    # Remove unwanted files.
    files = [os.path.join(folder_path, f)
                for f in files
                if not os.path.isdir(
                    os.path.join(folder_path, f)
                    )
            ]

    return files


def find_annotations(text: list) -> dict:

    ann_pattern = r'[A-Za-z0-9À-ÿ]+\|[0-9]+\|[A-Z]+\|[A-Z]+'

    annotations = list()

    # Run over text sents.
    for sent in text:
        annotation = re.findall(ann_pattern, sent)
        
        if annotation:
            annotations = annotations + annotation

    # annotations = re.findall(ann_pattern, text)

    name_ann = dict()

    for ann in annotations:
        s_ann = ann.split('|')
        t, annt = s_ann[0], '|'.join(s_ann[1:])

        name_ann[t] = annt

    return name_ann


def annotate_unnanotated(text: list, annotations: dict) -> list:

    # s_text = text.split()
    
    for i, sent in enumerate(text):
        s_sent = sent.split()
        for j, t in enumerate(s_sent):
            if t in annotations:
                annotation = annotations[t]
                s_sent[j] = f'{t}|{annotation}'
        text[i] = ' '.join(s_sent)

    return text


def look_for_person_names(text, person_names):
    # Break text into sentneces.
    # sents = text.split('\n')

    for person_name in person_names:

        p_name = person_name.split()

        positions = person_names[person_name]

        for pos in positions:
            pos = pos - 1
            if pos >= len(text):
                print(text)
                print(len(text))
                print(pos)
                continue
            # print(pos)
            # print(len(text))
            sent = text[pos]
            for p in p_name:
                index = sent.find(p)
                if index < 0:
                    continue
                sent_section = sent[index:]
                print(sent_section)
                word = sent_section.split()[0]
                print(word)
                if '|' not in word:
                    print(f"Found a name ({p}) that should be annotated.\n")
                    if pos > 0:
                        print(f"Previous text: {text[:pos-1]}\n")
                    print(f"Missing annotatioon: {text[pos]}\n")
                    # if pos < len(text) -1:
                    #     print(f"Next sent: {text[pos+1]}\n")
                    new_sent = input("Enter sentence: ")
                    if new_sent == '0':
                        continue
                    text[pos] = new_sent

    return text


def look_for_pronouns(text, pronouns):
    

    for i, sent in enumerate(text):
        tokens = sent.split()

        for t in tokens:
            if t.lower() in pronouns:
                print(f"Found a pronoun ({t}) that should be annotated.\n")
                if i > 0:
                    print(f"Previous text: {text[:i-1]}\n")
                print(f"Missing annotatioon: {text[i]}\n")
                # if i < len(tokens):
                #     print(f"Next sent: {text[i+1]}\n")
                new_sent = input("Enter sentence: ")
                if new_sent == '0':
                    continue
                text[i] = new_sent

    return text


def read_files(files: list, person_names: dict, pronouns: list):

    for f in files:
        # Avoid folders.
        if os.path.isdir(f):
            continue
        # Read file.
        print(f'Processing file: {f}')

        with open(f, 'r') as r_file:
            file_text = r_file.readlines()
            # file_text = '\n'.join(file_text)

            annotations = find_annotations(file_text)
            annotated_text = annotate_unnanotated(file_text, annotations)

            ff = os.path.split(f)[-1]
            f_raw = '.'.join(ff.split('.')[:-1]) # Remore .coref
            f_ner = f'{f_raw}.ner'              # Add .ner to fit keys in person_names.
            if f_ner not in person_names:
                continue

            file_person_names = person_names[f_ner]
            person_text = look_for_person_names(annotated_text, file_person_names)
            pronoun_text = look_for_pronouns(person_text, pronouns)

        head, tail = os.path.split(f)
        out_base = os.path.join(head, 'corrected')
        out_file = os.path.join(out_base, f'{tail}.corrected')

        with open(out_file, 'w') as w_file:
            for s in pronoun_text:
                w_file.write(f'{s}\n')
            

def process_person_names(person_names_path: str) -> dict:

    person_names_file = open(person_names_path, 'rb')
    person_names = pickle.load(person_names_file)

    person_names_file.close()

    return person_names


def process_pronouns(pronouns_path: str) -> list:

    pronouns_file = open(pronouns_path, 'r')
    pronouns = [term.strip() for term in pronouns_file.readlines()]
    pronouns_file.close()

    return pronouns
              

def main(folder_path: str, person_names_path: str, pronouns_path: str):
    
    files = process_files(folder_path)
    person_names = process_person_names(person_names_path)
    pronouns = process_pronouns(pronouns_path)

    read_files(files, person_names, pronouns)    


if __name__ == '__main__':
    folder_path = sys.argv[1]

    main(folder_path, person_names_path, pronouns_path)