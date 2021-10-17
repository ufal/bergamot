import os
import sys

"""
    Convert all data to a single file.
"""

all_pairs= ['ca-it', 'ca-oc', 'ca-ro', 'ca-en', 'ca-fr', 'ca-pt', 'ca-es',
             'en-it' 'en-oc' 'en-ro' 'es-it' 'es-oc' 'es-ro' 'fr-it' 'fr-oc' 'fr-ro']


def check_files(folder_path, files, s, t):

    source = ''
    target = ''

    for f in files:
        ext = f.split('.')[-1]
        if ext == s:
            source = f
            f_path = os.path.join(folder_path, f)
            s_lines = sum(1 for line in open(f_path))
        elif ext == t:
            target = f
            f_path = os.path.join(folder_path, f)
            t_lines = sum(1 for line in open(f_path))

        if source and target and s_lines == t_lines:
            return source, target

    return False


def process_files(folder_path, files, s, t, s_out, t_out):#, p_out):

    s_file, t_file = files
    s_path = os.path.join(folder_path, s_file)
    t_path = os.path.join(folder_path, t_file)

    # Read files.
    with open(s_path, 'r') as r_file:
        while True:
            line = r_file.readline()
            if not line:
                break
            s_out.write(line)
    with open(t_path, 'r') as r_file:
        while True:
            line = r_file.readline()
            if not line:
                break
            t_out.write(line)


def check_folder(folder_path, s, t, s_out, t_out):#, p_out=''):

    os.system(f"echo Looking in folder: {folder_path}")
    files = os.listdir(folder_path)

    # Check if the lang pair is in the folder.
    chkd_files = check_files(folder_path, files, s, t)
    if chkd_files:
        # Save the content to the single file.
        process_files(folder_path, chkd_files, s, t, s_out, t_out)#, p_out)

    # Look for more folders.
    for f in files:
        # Check if it is a folder.
        file_path = os.path.join(folder_path, f)
        if os.path.isdir(file_path):
            check_folder(file_path, s, t, s_out, t_out)


def create_structure(folder_path):

    # Create model, data, and out folders.
    data_path = folder_path+'/data'
    model_path = folder_path+'/model'
    out_path = folder_path+'/out'
    
    if not os.path.isdir(data_path):
        os.mkdir(data_path)
    if not os.path.isdir(model_path):
        os.mkdir(model_path)
    if not os.path.isdir(out_path):
        os.mkdir(out_path)

    return data_path


if __name__ == '__main__':

    root_path = sys.argv[1]
    lang_pair = sys.argv[2] # If 'all' run for all lang pairs.
    if len(sys.argv) == 4:
        out_path = sys.argv[3] # Folder to save files.
    else:
        out_path = None

    if not out_path:
        out_path = '../data/lang_pairs'

    # Check if out_path exists.
    if not os.path.isdir(out_path):
        os.mkdir(out_path)

    if lang_pair == 'all':
        lang_pairs = all_pairs
    else:
        lang_pairs = [lang_pair]

    for l_pair in lang_pairs:
        # Create a folder for the lang pair.
        folder_path = os.path.join(out_path, l_pair)
        if not os.path.isdir(folder_path):
            os.mkdir(folder_path)

        data_path = create_structure(folder_path)

        os.system(f"echo Processing language pair: {l_pair}")
        source, target = l_pair.split('-')

        s_path = os.path.join(data_path, f'all_texts.{l_pair}.{source}')
        s_out = open(s_path, 'w')
        t_path = os.path.join(data_path, f'all_texts.{l_pair}.{target}')
        t_out = open(t_path, 'w')

        check_folder(root_path, source, target, s_out, t_out)
        s_out.close()
        t_out.close()
