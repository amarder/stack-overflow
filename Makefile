my_db.sqlite: munge/xml2sql.py munge/keep.json $(DATA_FOLDER)/*.xml
	rm -f my_db.sqlite
	python munge/xml2sql.py $(DATA_FOLDER) my_db.sqlite

stack-overflow.pdf: stack-overflow.md stack-overflow.bib
	pandoc stack-overflow.md --biblio stack-overflow.bib --filter pandoc-citeproc -o stack-overflow.pdf

wc: stack-overflow.pdf
	pdftotext stack-overflow.pdf - | wc -w
