import os
from re import A
import sys
from typing import OrderedDict
import process_udpipe as pu
from nltk.tokenize.moses import MosesTokenizer


# Process NER to find the position of PERSON. (EN original names)

# Align with CS original names to obtain the names position in Czech.
# Save gender information from UDPipe.

# From the position in CS original, find the neutral name in CS neutral name.
# Save gender from them.


folder_path = sys.argv[1]
mode = sys.argv[2]

lang = 'en'
tokenizer = MosesTokenizer(lang=lang)


def process_ner(ner_line: str):
    # Find tags.
    per_pos = dict()

    line = ner_line.strip()
    s_line = line.split('\t')
    ls_line = len(s_line)

    if ls_line < 2:
        sent = line
        return sent, per_pos
    else:
        sent = s_line[0]
        tags = s_line[1]

    if tags == '\n':
        return sent, per_pos

    # Manipulate tags.
    t = tags.split('/')
    lt = len(t)
    if lt == 2:
        tags = [f'{t[0]}/{t[1]}']
    else:
        tags = [f"{t[0]}/{t[1].split(' ')[0]}"]+[
            f"{' '.join(t[x].split(' ')[1:])}/{t[x+1].split(' ')[0]}"
            for x in range(1, len(t) - 1)]

    t_sent = tokenizer.tokenize(sent)

    for t in tags:
        per, t = t.split('/')
        if t == 'PERSON':
            l_per = per.split()
            per = l_per[0] # Takes the first element.
            if per in t_sent:
                pos = t_sent.index(per)
                per_pos[per] = str(pos + 1)
            
    return t_sent, per_pos


def read_udpipe(udpipe_path):
    # Return dict sentences containing the annotation from udpipe.
    
    with open(udpipe_path, 'r') as r_file:

        sentences = OrderedDict()
        sent_id = 0

        while True:
            line = r_file.readline()

            if not line:
                break
        
            option = pu.selector(line)

            if option == 0:
                sentence = {'tok_ids' : OrderedDict()}
                sentence['text'] = pu.text_sentence(line)
                sentences[sent_id] = sentence
                sent_id = sent_id + 1
                continue
            elif option == 1:
                pu.process_token(sentence, line)
                continue
            elif option == 2:
                continue
            else:
                continue
        
    return sentences


def process_alignment(aligned_line: str):
    alignment = dict()

    align_sets = aligned_line.split()

    for align in align_sets:
        src, tgt = align.split('-')
        if src not in alignment:
            alignment[src] = [tgt]
        else:
            alignment[src].append(tgt)
    
    return alignment


def get_gender(udp_line, pos, look=False):

    gender = ''

    if not udp_line:
        return gender
    
    if 'feats' in udp_line['tok_ids'][pos]:
        if 'Gender' in udp_line['tok_ids'][pos]['feats']:
            gender = udp_line['tok_ids'][pos]['feats'].split('Gender')[1].split('|')[0][1:]
    
    if not gender and look:
        gender = look_for_gender(udp_line, pos)

    return gender


def look_for_gender(udp_dict, pos):

    level = 2 
    udp_gender = ''

    while level > 0:
        # Get head info.
        head = udp_dict['tok_ids'][pos]['head']
        if head == '0':
            return udp_gender
        udp_gender = get_gender(udp_dict, head)
        if not udp_gender:
            level = level - 1
        else:
            return udp_gender


def add_gender(counter, gender):

    if gender not in counter:
        counter[gender] = 1
    else:
        counter[gender] += 1


files = os.listdir(folder_path)

# Set paths for files.
ner_path = os.path.join(folder_path, 'ner')
ref_path = os.path.join(folder_path, 'references')
hyp_path = os.path.join(folder_path, 'czech')
udp_path = os.path.join(folder_path, 'udpipe')
align_path = os.path.join(folder_path, 'align')
aligned_path = os.path.join(folder_path, 'aligned')
out_path = os.path.join(folder_path, 'gender_analysis')


for f in files:

    # Ignore folders.
    if os.path.isdir(f):
        continue

    print(f'Processing file: {f}')

    # UDPipe version of base file (EN with original names).
    base_file = f'{f}.udp'
    base_file_path = os.path.join(udp_path, base_file)

    if not os.path.isfile(base_file_path):
        continue

    base_sents = read_udpipe(base_file_path)

    # NER file form base file.
    ner_file = f'{f}.ner'

    # Given the file name, we start looking for its ner version.
    ner_file_path = os.path.join(ner_path, ner_file)

    if not os.path.isfile(ner_file_path):
        print(f"Could not find: {ner_file_path}")
        continue

    ner_read = open(ner_file_path, 'r')

    # Open auxiliar files.

    # Translation from original name.
    ref_file = f'{f}.{mode}.cs.udp'
    ref_file_path = os.path.join(udp_path, ref_file)

    if not os.path.isfile(ref_file_path):
        print(f"Could not find file: {ref_file_path}")
        continue
    
    # Read UDPipe format.
    ref_sents = read_udpipe(ref_file_path)

    # Translation from neutral name.
    hyp_file = f'{f}.ner.nn.{mode}.cs.udp'
    hyp_file_path = os.path.join(udp_path, hyp_file)

    # Read UDPipe format.
    hyp_sents = read_udpipe(hyp_file_path)
  
    # Aligned file between en-cs with original names.
    aligned_file = f'{f}.en-cs.aligned'
    aligned_file_path = os.path.join(aligned_path, aligned_file)
    aligned_read = open(aligned_file_path, 'r')

    # Out file.
    out_file = f'{f}.analysis'
    out_file_path = os.path.join(out_path, out_file)
    out_write = open(out_file_path, 'w')
    out_write.write('sent_id\tbase_gender\tref_gender\thyp_gender\n')

    sent_counter = 0
    base_counter = dict()
    ref_counter = dict()
    hyp_counter = dict()

    while True:

        # Read NER line.
        ner_line = ner_read.readline()
        alg_line = aligned_read.readline()

        if not ner_line:
            break

        alignment = process_alignment(alg_line) # Returns dict with a list of positions.

        t_sent, person_position = process_ner(ner_line)

        # Read udpipe sents.
        base_sent = base_sents[sent_counter]
        ref_sent = ref_sents[sent_counter]
        hyp_sent = hyp_sents[sent_counter]

        sent_counter = sent_counter + 1

        if not person_position:
            # No person found.
            continue

        # Look for person in Czech original name.

        for per in person_position:
            
            pos = person_position[per]
            
            base_gender = ''

            if pos not in base_sent['tok_ids']:
                continue
            
            base_gender = get_gender(base_sent, pos, look=True)

            if base_gender:
                add_gender(base_counter, base_gender)

            # Czech original name.
            if pos not in alignment:
                continue
            cs_org_pos = alignment[pos]

            ref_gender = ''
            hyp_gender = ''

            for cs_pos in cs_org_pos:

                if not ref_gender:
                    if cs_pos in ref_sent['tok_ids']:
                        ref_gender = get_gender(ref_sent, cs_pos, look=True)

                if not hyp_gender:
                    if cs_pos in hyp_sent['tok_ids']:
                        hyp_gender = get_gender(hyp_sent, cs_pos, look=True)

            if ref_gender:
                add_gender(ref_counter, ref_gender)

            if hyp_gender:
                add_gender(hyp_counter, hyp_gender)

            if base_gender or ref_gender or hyp_gender:
                out_line = f'{sent_counter+1}\t{base_gender}\t{ref_gender}\t{hyp_gender}\n'
                out_write.write(out_line)

    for s, t in [('Base', base_counter),  ('Ref', ref_counter), ('Hyp', hyp_counter)]:
        
        out_write.write(f'\n\nGender Stats ({s}):\n')
        for g in t:
            out_write.write(f'{g}: {t[g]}\n')

    ner_read.close()
    aligned_read.close()
    out_write.close()