import os
import sys

org_path = "../data/wmt21/test_en-cs/"
aux_out_path = "../data/wmt21/test_en-cs/czech/"
translate_script = "./translate-lindat.sh"


def translate_file(f_path, out_path, model_type='doc'):
    
    # Correct path.
    _, tail = os.path.split(f_path)
    
    # Remove extra annotations.
    org_name = '.'.join(tail.split('.')[:-2])
    
    org_out_path = os.path.join(org_path, org_name)

    out_folder = os.path.join(out_path, model_type)
    if not os.path.isdir(out_folder):
        os.mkdir(out_folder)

    org_file_path = os.path.join(out_folder, org_name)
    out_file = f"{org_file_path}.{model_type}.cs"

    os.system(f"sh {translate_script} en cs {model_type} < {org_out_path} > {out_file}")


def read_files(folder_path: str):
    # Read files with the .coref.corrected extension.

    files  = os.listdir(folder_path)

    return [
            os.path.join(folder_path, f)
            for f in files
                if not f.endswith('.cs')
                and not os.path.isdir(os.path.join(folder_path, f))
                ]


def main(folder_path: str, model_type: str, model_name:str,  out_path='') -> None:
    
    if not out_path:
        # Place translated files in aux_out_path.
        out_path = aux_out_path

    out_path = os.path.join(out_path, model_name)

    if not os.path.isdir(out_path):
        os.mkdir(out_path)

    if os.path.isdir(folder_path):
        files = read_files(folder_path)
        for f in files:
            translate_file(f, out_path, model_type=model_type)
    elif os.path.isfile(folder_path):
        translate_file(folder_path, out_path, model_type=model_type)


if __name__ == '__main__':

    folder_path = sys.argv[1] # Accepts both path or file.
    model_type = sys.argv[2]
    model_name = sys.argv[3]
    if len(sys.argv) > 4:
        out_path = sys.argv[4]
    else:
        out_path = ''

    if out_path:
        main(folder_path, model_type, model_name, out_path)
    else:
        main(folder_path, model_type, model_name)
