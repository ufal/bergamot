import os
import sys
from nltk.tokenize.moses import MosesTokenizer
from ufal.udpipe import Model, Pipeline, ProcessingError

udpipe_models_path = '/home/aires/personal_work_troja/repos/udpipe/models'
# Add models here if you want to work with other languages.
udpipe_models = {'en': 'english-partut-ud-2.5-191206.udpipe',
                 'fr': 'french-gsd-ud-2.5-191206.udpipe',
                 'de': 'german-hdt-ud-2.5-191206.udpipe',
                 'cs': 'czech-cac-ud-2.5-191206.udpipe'}

f_path = sys.argv[1]
lang = sys.argv[2]

o_path = f_path + '.udp'


tokenizer = MosesTokenizer(lang=lang)


# Define the model.
udp_model_path = os.path.join(udpipe_models_path, udpipe_models[lang])

udp_model = Model.load(udp_model_path)

parser = Pipeline(udp_model, 'horizontal', Pipeline.DEFAULT, Pipeline.DEFAULT, 'conllu')

error = ProcessingError()

with open(f_path, 'r') as r_file, open(o_path, 'w') as w_file:
    while True:
        # Read line.
        line = r_file.readline()
        if not line:
            break
        tok_line = tokenizer.tokenize(line, return_str=True)
        # Parse lines.
        p_line = parser.process(tok_line, error)
        w_file.write(p_line + '\n')
