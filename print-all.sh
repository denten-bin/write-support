pandoc metadata.yaml *.md \
    --smart \
    --normalize \
    --toc-depth=2 \
    --standalone \
    --latex-engine=xelatex \
    --filter pandoc-citeproc \
    -o print-plates/plain-text-manuscript.pdf
