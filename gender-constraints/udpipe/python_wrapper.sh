#!/bin/bash

. /home/aires/personal_work_troja/python_envs/style_transf/bin/activate

#python identify_gender.py en /home/aires/personal_work_troja/style_transfer/data/gender/fr-en/europarl.remainder.fr-en.en 

#python identify_gender.py en /home/aires/personal_work_troja/style_transfer/data/gender/fr-en/europarl.remainder.fr-en.en --lang2 fr --doc2 /home/aires/personal_work_troja/style_transfer/data/gender/fr-en/europarl.remainder.fr-en.fr --alignment ../../data/gender/fr-en/europarl.remainder.fr-en.en-fr.align

#python identify_gender.py en /home/aires/personal_work_troja/style_transfer/data/gender/de-en/europarl.remainder.de-en.en --lang2 de --doc2 /home/aires/personal_work_troja/style_transfer/data/gender/de-en/europarl.remainder.de-en.de --alignment ../../data/gender/de-en/europarl.remainder.de-en.en-de.align

#python identify_gender.py en de ../../data/gender/de-en/europarl.remainder.de-en.en-de ../../data/gender/de-en/europarl.remainder.de-en.en-de.align.test

#python identify_gender.py en fr ../../data/gender/fr-en/europarl.remainder.fr-en.en-fr ../../data/gender/fr-en/europarl.remainder.fr-en.en-fr.align.test

#python identify_gender.py en fr True -d1 ../../data/gender/fr-en/europarl.remainder.fr-en.en -d2 ../../data/gender/fr-en/europarl.remainder.fr-en.fr

#python identify_gender.py en de True -d1 ../../data/gender/de-en/europarl.remainder.de-en.en -d2 ../../data/gender/de-en/europarl.remainder.de-en.de


#python identify_gender.py en fr -a  /home/aires/personal_work_troja/style_transfer/marian_models/test_set/wmt14-en-fr.tok.align -af /home/aires/personal_work_troja/style_transfer/marian_models/test_set/wmt14-en-fr.tok.aligned --out /home/aires/personal_work_troja/style_transfer/marian_models/test_set/wmt14-en-fr.new.tok

python udpipe_annotate.py $1 $2
