#!/bin/bash
SRCLANG=${1:-"en"}
TGTLANG=${2:-"cs"}
DOC=${3:-"sent"}

if [ "$DOC" = "sent" ]
then
    cat /dev/stdin | while read -r line; do
    line=`echo $line | sed "s/'/\\\\\'/g"`
    curl \
        -X POST "https://lindat.mff.cuni.cz/services/translation/api/v2/models/${SRCLANG}-${TGTLANG}?src=${SRCLANG}&tgt=${TGTLANG}" \
        -H "accept: text/plain" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "input_text=${line}"
    done
elif [ "$DOC" = "doc" ]
then
text=$(cat /dev/stdin)
curl \
    -X POST "https://lindat.mff.cuni.cz/services/translation/api/v2/models/doc-${SRCLANG}-${TGTLANG}?src=${SRCLANG}&tgt=${TGTLANG}" \
    -H "accept: text/plain" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "input_text=${text}"
fi


