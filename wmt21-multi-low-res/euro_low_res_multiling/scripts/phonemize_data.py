import os
import sys
from phonemizer import phonemize

backend = 'espeak'


def process_file(file_path, lang):

    os.system(f"echo Processing file: {file_path}")
    # Set output file.
    out_file = file_path + '.phon'

    with open(out_file, 'w') as w_file:
        with open(file_path, 'r') as r_file:
            while True:
                line = r_file.readline()
                if not line:
                    break
                try:
                    phon_line = phonemize(line, language=lang, backend=backend)
                    w_file.write(phon_line + '\n')
                except:
                    w_file.write(line)

def check_folder(folder_path, lang):
    os.system(f"echo Processing folder: {folder_path}")
    # List files.
    files = os.listdir(folder_path)

    for f in files:
        
        file_path = os.path.join(folder_path, f)
        # If folder, check folder.
        if os.path.isdir(file_path):
            check_folder(file_path, lang)
        elif os.path.isfile(file_path):
            ext = file_path.split('.')[-1]
            if ext == lang:
#                if os.path.isfile(file_path+'.phon'):
#                    continue
                process_file(file_path, lang)


if __name__ == '__main__':
    # Look for .ca/.cat files and create a phonemized version of them.
    root_folder = sys.argv[1]
    lang = sys.argv[2]

    check_folder(root_folder, lang)


