import os
# import sys


def setup_alignment(file_path_1: str, file_path_2: str) -> str:
    # Create a setup file for alignment between file_path_1 and file_path_2.
    # Ex.: I love cats . ||| J'aime les chats.

    # Take the base name of files.
    head, base_name_1 = os.path.split(file_path_1)
    _, base_name_2 = os.path.split(file_path_2)
    base_name = f'{base_name_1}-{base_name_2}'

    out_path = os.path.join(head, base_name)

    with open(file_path_1, 'r') as r_file_1, open(file_path_2, 'r') as r_file_2, open(out_path, 'w') as w_file:
        
        while True:
            line1 = r_file_1.readline()
            line2 = r_file_2.readline()

            if not line1:
                break

            w_file.write(f'{line1.strip()} ||| {line2.strip()}\n')
    
    return out_path


def align_file(align_file: str) -> str:
    
    fast_align = "/home/aires/personal_work_troja/repos/fast_align/build/fast_align"

    out_file = f'{align_file}.aligned'

    os.system(f"{fast_align} -i {align_file} -d -o -v > {out_file}")
    os.system(f"rm {align_file}")  # Remove align setup to avoid multiple files.

    return out_file


def struct_alignment(aligned_file: str) -> dict:

    alignment = dict()

    l_counter = 0

    with open(aligned_file, 'r') as r_file:
        while True:
            line = r_file.readline()
            if not line:
                break
            
            alignment[l_counter] =  dict()

            als = line.split()

            for al in als:
                s, t = al.split('-')

                if s not in alignment:
                    alignment[l_counter][s] = [t]
                else:
                    alignment[l_counter][s].append(t)
            
            l_counter += 1
    
    return alignment
