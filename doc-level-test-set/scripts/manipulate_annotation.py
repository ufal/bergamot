import os
import re
import sys
import copy
from collections import OrderedDict
from pronoun_gender_dict import pronoun_dict


class AnnotatedDoc:
    """
        Create a structure to an annotated document.
        Allows the manipulation of the document.
    """

    def __init__(self, file_path: str) -> None:
        """
        Parameters
        ----------
        file_path : str
            Path to the document containing annotations.
        """

        self.f_path = file_path
        self.sents = open(self.f_path, 'r').readlines()
        self.tokens = OrderedDict()
        self.annotated = list()
        for i in range(len(self.sents)):
            self.tokens[i] = self.sents[i].split()
            for j in range(len(self.tokens[i])):
                if self.has_annotation(self.tokens[i][j]):
                    self.annotated.append((i,j))
        self.annotations = self.get_annotations()

    def has_annotation(self, token: str) -> bool:
        """
        Verify whether token has an annotation.
        Parameters
        ----------
        token : str
            String containing a sentence or a single token.
        """

        annotation = r"\|[0-9][0-9]*\|[A-Z]+\|[A-Z]+"

        if re.findall(annotation, token):
            return True
        
        return False
                           
    def get_annotations(self) -> dict:
        
        annotations = dict()

        for i in range(len(self.annotated)):
            # Select annotation.
            sent_id, token_id = self.annotated[i]
            ann_token = self.tokens[sent_id][token_id]
            
            tok, person_id, ann_type, gender = ann_token.split('|')
            # Fill annotations.
            if person_id not in annotations:
                annotations[person_id] = list()
            ann = {'token': tok, 'type': ann_type, 'gender': gender, 'tok_pos': token_id, 'sent_pos': sent_id}
            annotations[person_id].append(ann)

        return annotations

    def remove_annotation(self, tokens: dict) -> dict:

        new_tokens = dict()

        for i in tokens:
            new_tokens[i] = list()
            for tok in tokens[i]:
                if self.has_annotation(tok):
                    term = tok.split('|')[0]
                    new_tokens[i].append(term)
                else:
                    new_tokens[i].append(tok)
        
        return new_tokens

    def export_doc(self, out_path: str, tokens: dict) -> None:
        # Tokens must have no annotation, use self.remove_annotation().
        extra_spaces = re.compile(r' +')
        with open(out_path, 'w') as w_file:
            for sent_id in tokens:
                sent = ''
                for token in tokens[sent_id]:
                    if not sent:
                        sent = f"{token}"
                    else:
                        sent = f"{sent} {token}"
                sent = re.sub(extra_spaces, ' ', sent)
                w_file.write(f'{sent}\n')
    
    def print_annotations(self, annotations: dict) -> None:
        
        for ann_id in annotations:
            print(f"Annotation ID: {ann_id}")
            for ann in annotations[ann_id]:
                print(f"\tToken: {ann['token']}\n")
                print(f"\tType: {ann['type']}\n")
                print(f"\tGender: {ann['gender']}")
    
    def fix_multigender(self, annotations: dict) -> None:

        for ann_id in annotations:
            # Get the most frequent gender.
            # Change the wrong one to the mode.
            gender = dict()
            for ann in annotations[ann_id]:
                g = ann['gender']
                if g not in gender:
                    gender[g] = 1
                else:
                    gender[g] += 1
            
            if len(gender.keys()) > 1:
                mode = max(gender, key=lambda x: gender[x])

                for ann in annotations[ann_id]:
                    g = ann['gender']
                    if g != mode:
                        ann['gender'] = g

    def modify_name(self, ann_id: str, name: str) -> dict:
        
        compounded = self.identify_compounded(ann_id)
        new_tokens = copy.deepcopy(self.tokens)

        for ann in self.annotations[ann_id]:
            if ann['type'] == 'PROPER':
                token_id = ann['tok_pos']
                sent_id = ann['sent_pos']
                # Deal with compounded.
                if sent_id in compounded:
                    if token_id in compounded[sent_id]:
                        first = True
                        for comp in compounded[sent_id]:
                            if first:
                                tok = new_tokens[sent_id][comp].split('|')
                                tok[0] = name
                                new_tokens[sent_id][comp] = '|'.join(tok)
                                first = False
                            else:
                                new_tokens[sent_id][comp] = ''
                        break
                    compounded[sent_id].remove(comp)
                else:
                    tok = new_tokens[sent_id][token_id].split('|')
                    tok[0] = name
                    new_tokens[sent_id][token_id] = '|'.join(tok)
            
        return new_tokens

    def identify_compounded(self, ann_id: str):

        proper = dict()

        compounded = dict()

        for ann in self.annotations[ann_id]:
            # Select only PROPER NAMES.
            if ann['type'] == 'PROPER':
                # Divide them by the sentence they are.
                if ann['sent_pos'] not in proper:
                    proper[ann['sent_pos']] = [ann['tok_pos']]
                else:
                    proper[ann['sent_pos']].append(ann['tok_pos'])
        
        for sent_id in proper:
            compounding = False # Flag that indicates when working on a compounded name.
            person_name = list() # Save token ids.
            sorted_token_ids = sorted(proper[sent_id]) # Sort them to have a sequence.
            
            for ind, token_id in enumerate(sorted_token_ids):
                if ind + 1 < len(sorted_token_ids): # Make sure we are working inside the limits.
                    if token_id + 1 == sorted_token_ids[ind+1]: # If the next token_id is +1, we confirm it is a sequence.
                        # Compounded name.
                        compounding = True
                        # Add both token ids to the list.
                        person_name.append(token_id)
                        person_name.append(token_id + 1)
                        compounded[sent_id] = list(set(person_name))
                    else:
                        # When diffent, check if it is not finishing an existing sequence.
                        if compounding:
                            person_name = set(person_name) # Remove duplicates.
                            person_name = list(person_name) # Turn into a list again.
                            if sent_id in compounded:
                                compounded[sent_id].append(person_name) # List of lists.
                            else:
                                compounded[sent_id] = [person_name]
                            # Reset name and flag.
                            person_name = list()
                            compounding = False

        return compounded

    def modify_gender(self, ann_id: str, gender: str) -> dict:
        # Make sure annotations are consistent.
        # WARNING: It will change pronouns, but not names.
        # It will change only the information from annotation and the pronouns.
        # Return tokens.
        new_tokens = copy.deepcopy(self.tokens)

        self.fix_multigender(self.annotations)

        for ann in self.annotations[ann_id]:
            if ann['gender'] != gender:
                # Check if it is proper name or pronoun.
                ann['gender'] = gender

                if ann['type'] == 'PRONOMINAL':
                    # Map pronoun to a different gender.
                    token = ann['token']
                    if token not in pronoun_dict:
                        print(f"Could not find {token} in {pronoun_dict}")
                        sys.exit(1)

                    new_pronoun = pronoun_dict[token]
                    # Add to new tokens.
                    sent_id = ann['sent_pos']
                    token_id = ann['tok_pos']
                    tok = new_tokens[sent_id][token_id].split("|")
                    tok[0] = new_pronoun
                    tok[-1] = gender
                    new_tokens[sent_id][token_id] = "|".join(tok)
                
                elif ann['type'] == "PROPER":
                    sent_id = ann['sent_pos']
                    token_id = ann['tok_pos']
                    tok = new_tokens[sent_id][token_id].split("|")
                    tok[-1] = gender
                    new_tokens[sent_id][token_id] = "|".join(tok)
        
        return new_tokens


if __name__ == "__main__":

    a_doc = AnnotatedDoc('../data/wmt21/test_en-cs/ner/corefs/corrected/abcnews.420184.coref.corrected')
    new_tokens = a_doc.modify_gender('68', 'FEMALE')
    
    a_doc.export_doc('/home/aires/Desktop/my_test_annotated.txt', new_tokens)
    
    new_tokens = a_doc.remove_annotation(new_tokens)
    a_doc.export_doc('/home/aires/Desktop/my_test.txt', new_tokens)