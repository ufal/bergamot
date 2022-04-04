#!/bin/bash

. /home/aires/personal_work_troja/repos/gender-constraints/gender/bin/activate

#python remove_xml.py $1
#python ner.py $1 $2

#python process_data4doc.py $1 $2

#python replace_names.py $1 

#python split_references.py 
#python list_person_names.py

python translate_doc.py /home/aires/personal_work_troja/repos/gender-constraints/doc_gender/data/wmt21/test_en-cs/ner/corefs/corrected doc

#python calculate_score.py /home/aires/personal_work_troja/doc_annotation/test_scenario/source/ /home/aires/personal_work_troja/doc_annotation/test_scenario/annotated /home/aires/personal_work_troja/doc_annotation/test_scenario/target
