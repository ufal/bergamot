import os
import re
import sys
import logging
import align_files as af
from udpipe_annotate import UDPipeAnnotator

logging.basicConfig(level=logging.INFO)


class CalculateScore():

    def __init__(self, s_path: str, a_path: str, t_path: str, src: str, tgt: str) -> None:
        
        self.sou_path = s_path
        self.ann_path = a_path
        self.tra_path = t_path
        self.src = src
        self.tgt = tgt
        self.ud_annotator = None
        self.gender_dict = {
            'Masc': 'MALE',
            'Fem': 'FEMALE',
            'Neut': 'NEUTRAL',
        }
        self.acc = 0

    def set_udpipe(self, lang) -> None:
        self.ud_annotator = UDPipeAnnotator(lang)

    def get_files(self, path: str) -> list:
        files = os.listdir(path)

        files = [os.path.join(path, f)
                    for f in files
                    if not os.path.isdir(f)
                    ]

        return files

    def evaluate(self) -> None:
        
        # Check udpipe annotator.
        if not self.ud_annotator:
            logging.info(f'Setting up udpipe annotator: {self.tgt}')
            self.set_udpipe(self.tgt)

        # Counts for score.
        annotations = 0
        correct = 0

        # Get all files.
        a_files = self.get_files(self.ann_path)
        t_files = self.get_files(self.tra_path)
        s_files = self.get_files(self.sou_path)

        logging.info(f"Stats about files:\nAnnotated: {len(a_files)}\nTranslated: {len(t_files)}\nSource: {len(s_files)}\n")

        for a_file in a_files:

            logging.info(f"Working on {a_file}")

            # Find the same files for the rest of them.
            t_file = self.find_file(a_file, t_files)
            s_file = self.find_file(a_file, s_files)

            if not t_file or not s_file:
                print(f"Could not find a file: {t_file}, {s_file}")
                continue

            logging.info(f"Found: {t_file} and {s_file}")

            # Align source and target.
            align = af.setup_alignment(s_file, t_file)
            aligned = af.align_file(align)
            strct = af.struct_alignment(aligned)

            logging.info(f'Aligned successfully: {strct.keys()}')

            l_counter = 0
            # Read file.
            with open(a_file, 'r') as r_ann, open(t_file, 'r') as r_tra:
                while True:
                    a_line = r_ann.readline()
                    t_line = r_tra.readline()
                    print(a_line, t_line)
                    if not a_line:
                        break
                   
                    # Check if has annotation.
                    if not self.has_annotation(a_line):
                        l_counter = l_counter + 1
                        continue
                    
                    logging.info(f'Found annnotation: {a_line}')

                    a_line_split = a_line.split()
                                       
                    logging.info(f"Corresponding target sentence: {t_line}")
                    # Process Translated file using UDPipe.
                    ud_line = self.ud_annotator.annotate(t_line)
                    
                    if l_counter in strct:
                        line_strct = strct[l_counter]
                        logging.info(f"Found alignment on line {l_counter}: {line_strct}")
                    else:
                        print(f"Could not find {l_counter} in {strct.keys()}")
                        continue
                    ann, corr = self.analyze_gender(a_line_split, line_strct, ud_line)

                    # Update counters.
                    annotations = annotations + ann
                    correct = correct + corr
                    print(f"Correct: {correct}; Annotations: {annotations}")
                    if annotations == 0:
                        self.acc = 0
                    else:
                        self.acc = correct / annotations
                    l_counter = l_counter + 1
    
    def find_file(self, main_file: str, file_list: list) -> str:
        
        # Remove path.
        _, tail = os.path.split(main_file)
        # Take base name.
        base_name = '.'.join(tail.split('.')[:-2])  # Removes .coref.corrected
        # Count the number of full stops.
        n_stops = base_name.count('.')

        for f in file_list:
            _, tail = os.path.split(f)

            file_name = '.'.join(tail.split('.')[:n_stops+1])
            if base_name == file_name:
                return f
        
        return ''

    def has_annotation(self, line: str) -> bool:

        annotation = r'\|[0-9][0-9]*\|[A-Z]+\|[A-Z]+'

        if re.findall(annotation, line):
            return True
        
        return False

    def analyze_gender(self, a_line: list, strct: dict, ud_line: dict) -> tuple:

        ann_counter = 0
        correct = 0

        # Find tokens with annotation.
        for i, token in enumerate(a_line):

            if not self.has_annotation(token):
                continue
            
            s_annotation = token.split('|')
            s_gender = s_annotation[-1]
            print(f"Annotated token: {token}")
            # Find the token in source.
            if str(i) in strct:
                t_ids_token = strct[str(i)]
                logging.info(f"Found ids for token {s_annotation[0]}, index {i}: {t_ids_token}")
            else:
                print(f"Line-level: Could not find {i} in {strct.keys()}")
                #sys.exit(1)
                continue
            
            logging.info(f"This token has annotation: {token}, gender: {s_gender}")

            for t_id in t_ids_token:
                ud_id = str(int(t_id) + 1)
                t_token = ud_line['tok_ids'][ud_id]
                print(f"Id: {ud_id}, Tgt token: {t_token}")
                if 'Gender' in t_token['feats']:
                    # Extract the gender in the token.
                    ann_counter = ann_counter + 1
                    t_gender = t_token['feats'].split('Gender')[1].split('|')[0][1:]
                    if ',' in t_gender:
                        t_gender = t_gender.split('=')[-1].split(',')[0] 
                    logging.info(f"Found gender in target token: {t_token} {t_token['feats']}")
                    logging.info(f"Gender post-translation: {self.gender_dict[t_gender]}")
                    if s_gender == self.gender_dict[t_gender]:
                        correct = correct + 1
                        break

        return ann_counter, correct


if __name__ == '__main__':

    s_path = sys.argv[1]
    a_path = sys.argv[2]
    t_path = sys.argv[3]
    src = 'en'
    tgt = 'cs'

    cs = CalculateScore(s_path, a_path, t_path, src, tgt)

    cs.evaluate()
    with open('result.txt', 'w') as w_file:
        w_file.write(f"Accuracy: {cs.acc}")
    print(cs.acc)
