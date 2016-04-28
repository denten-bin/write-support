#!/bin/bash
#
# Save time when constructing complex pandoc incantations.
#
# USUAGE:
#           sh print.sh [-p|-d|-m] filename.md
#
#           -p to produce .pdf
#           -d for .docx
#           -m for .md hardwrap > .md softwrap with normalization
#           -y for pdfs without standalone yaml
#
# this last one is useful for sharing and 

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

# todo: add --reference-docx for -d
# handle three options with getopts
while getopts ":d:p:m:y:" opt; do
  case $opt in
    d)
      echo "printing $source to print-plates/$target.docx " >&2
      pandoc "$yaml" "$source" \
          --smart \
          --normalize \
          --standalone \
          --filter pandoc-citeproc \
          -o print-plates/"$target".docx
      ;;
    p)
      echo "printing $source to print-plates/$target.pdf " >&2
      pandoc "$yaml" "$source" \
          --smart \
          --normalize \
          --standalone \
          --latex-engine=xelatex \
          --filter pandoc-citeproc \
          -o print-plates/"$target".pdf
      ;;
    m)
      echo "printing $target.md to print-plates/" >&2
      pandoc "$source" \
          --smart \
          --normalize \
          --standalone \
          -f markdown \
          -t markdown+hard_line_breaks \
          -o print-plates/"$target".md
      ;;
    y)
      echo "printing $source to print-plates/$target.pdf " >&2
      pandoc "$source" \
          --smart \
          --normalize \
          --standalone \
          --latex-engine=xelatex \
          --filter pandoc-citeproc \
          -o print-plates/"$target".pdf
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

