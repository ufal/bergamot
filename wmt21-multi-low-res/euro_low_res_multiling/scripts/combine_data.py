import os
import sys

"""
    Convert all data to a single file.
"""

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
        

if __name__ == '__main__':

    root_path = sys.argv[1]
    lang_pair = sys.argv[2]
    out_path = sys.argv[3] # Folder to save files.

    # Create a folder for the lang pair.
    folder_path = os.path.join(out_path, lang_pair)
    if not os.path.isdir(folder_path):
        os.mkdir(folder_path)

    os.system(f"echo Processing language pair: {lang_pair}")
    source, target = lang_pair.split('-')

    s_path = os.path.join(folder_path, f'all_text.{lang_pair}.{source}')
    s_out = open(s_path, 'w')
    t_path = os.path.join(folder_path, f'all_text.{lang_pair}.{target}')
    t_out = open(t_path, 'w')

    check_folder(root_path, source, target, s_out, t_out)
    s_out.close()
    t_out.close()

