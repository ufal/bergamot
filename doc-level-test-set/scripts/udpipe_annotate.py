from concurrent.futures import process
import os
import sys
from nltk.tokenize.moses import MosesTokenizer
from process_udpipe import process_file
from ufal.udpipe import Model, Pipeline, ProcessingError

udpipe_models_path = '/home/aires/personal_work_troja/repos/udpipe/models'
# Add models here if you want to work with other languages.
udpipe_models = {'en': 'english-partut-ud-2.5-191206.udpipe',
                 'fr': 'french-gsd-ud-2.5-191206.udpipe',
                 'de': 'german-hdt-ud-2.5-191206.udpipe',
                 'cs': 'czech-cac-ud-2.5-191206.udpipe'}


class UDPipeAnnotator():

    def __init__(self, lang) -> None:
        self.lang = lang
        if lang in udpipe_models:
            self.ud_path = os.path.join(udpipe_models_path, udpipe_models[lang])
        else:
            print(f"Select a valid langauge: {udpipe_models.keys()}")
        
        self.tokenizer = MosesTokenizer(lang=lang)
        print(self.ud_path)
        self.udp_model = Model.load(self.ud_path)
        self.parser = Pipeline(self.udp_model, 'horizontal', Pipeline.DEFAULT, Pipeline.DEFAULT, 'conllu')
        self.error = ProcessingError()

    def annotate(self, line: str) -> dict:
    
        tok_line = self.tokenizer.tokenize(line, return_str=True)
        # Parse line.
        p_line = self.parser.process(tok_line, self.error)
        sentence = process_file(p_line)

        return sentence
