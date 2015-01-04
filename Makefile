stack-overflow.pdf: stack-overflow.md stack-overflow.bib
	pandoc stack-overflow.md --biblio stack-overflow.bib --filter pandoc-citeproc -o stack-overflow.pdf

wc: stack-overflow.pdf
	pdftotext stack-overflow.pdf - | wc -w


