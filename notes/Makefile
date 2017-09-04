# for latex
all:
	max_print_line=1000 pdflatex -file-line-error -draftmode -halt-on-error -interaction=nonstopmode ../src/file.tex && \
	bibtex file.aux && \
	max_print_line=1000 pdflatex -file-line-error -draftmode -halt-on-error -interaction=nonstopmode ../src/file.tex && \
	max_print_line=1000 pdflatex -file-line-error -halt-on-error -interaction=nonstopmode ../src/file.tex
