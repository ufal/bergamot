import os
import sys

clean_path = "/home/aires/Documents/repositories/gender-constraints/doc_gender/data/wmt21/test-src/en-cs"


def find_person(file_path: str) -> bool:

    found_person = False

    with open(file_path, 'r') as r_file:
        while True:
            line = r_file.readline()
            if not line:
                break
            
            # Break line.
            tags = line.split('\t')

            if len(tags) < 2:
                continue

            # Verify whether PERSON is one of the tags.
            if 'PERSON' in tags[1]:
                found_person = True
                print("Found person")
                return found_person

    return found_person


def save_file(file_path: str, out_path: str):
    # Copy file to new location.
    os.popen(f'cp {file_path} {out_path}')


def set_out_path(f_path):
    
    out_folder_name = 'person_files'
    out_path = os.path.join(f_path, out_folder_name)

    if not os.path.isdir(out_path):
        os.mkdir(out_path)

    return out_path


def get_clean_file_path(file_path):

    # Find filename.
    filename = file_path.split('/')[-1]
    l_filename = filename.split('.')
    filename = '.'.join(l_filename[:-1])
    
    new_file_path = os.path.join(clean_path, filename)

    # Check if it exists.
    if not os.path.isfile(new_file_path):
        print(f"Creating a bad file path: {new_file_path}")
        sys.exit(1)
    
    return new_file_path


def select_files(f_path: str, files: list):

    p_files = list() # List containing paths to files that have at least one PERSON identified.

    # Read files.
    for f in files:
        file_path = os.path.join(f_path, f)
        
        if os.path.isdir(file_path):
            continue

        person = find_person(file_path)

        if person:
            new_file_path = get_clean_file_path(file_path)
            p_files.append(new_file_path)

    return p_files


def main(folder_path: str, out_path=''):
    
    if not out_path:
        out_path = set_out_path(folder_path)

    # List files.
    if not os.path.isdir(folder_path):
        print("Please provide a valid folder path.")
        sys.exit(1)

    files = os.listdir(folder_path)
    
    # Process files.
    person_files = select_files(folder_path, files)

    print(person_files)

    # Save files.
    for f in person_files:
        save_file(f, out_path)


if __name__ == '__main__':

    folder_path = sys.argv[1]
    
    main(folder_path)