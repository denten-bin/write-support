#!/bin/bash
# This script saves time when constructing complex pandoc incantations
#
# USUAGE:
#           sh print.sh [-p | -d] filename.md
#
#           -p to produce .pdf
#           -d for .docx

## pass the file name as an argument
if [ $# -eq 0 ]
then
        echo "pass the file name"
        exit
fi

source=$2

# Use parameter expansion to strip the name
target="${source%%.*}"

# check if the .yaml is in separate file
# this is nice for when the same files share the same yaml header
# if not just stuff with a harmless duplicate --verbose
if test -f metadata.yaml
then
    yaml="metadata.yaml"
else
    yaml="--verbose"
fi

# handle two options with getopts: -d for .docx and -p for .pdf

while getopts ":d:p:m:" opt; do
  case $opt in
    d)
      echo "printing $source to print-plates/$target.docx " >&2
      pandoc -s "$source" "$yaml" \
          --verbose \
          --normalize \
          --filter pandoc-citeproc \
          --csl ~/bin/write-support/csl/mla-note.csl \
          -So print-plates/"$target".docx
      ;;
    p)
      echo "printing $source to print-plates/$target.pdf " >&2
      pandoc -s "$source" "$yaml" \
          --verbose \
          --normalize \
          --latex-engine=xelatex \
          --filter pandoc-citeproc \
          --csl ~/bin/write-support/csl/mla-no-biblio.csl \
          -So print-plates/"$target".pdf
      ;;
    m)
      echo "printing $target.md to print-plates/" >&2
      pandoc "$source" \
          --verbose \
          --normalize \
          -f markdown \
          -t markdown+hard_line_breaks \
          -So print-plates/"$target".md
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

