my_db.sqlite: munge/xml2sql.py munge/keep.json $(DATA_FOLDER)/*.xml
	rm -f my_db.sqlite
	python munge/xml2sql.py $(DATA_FOLDER) my_db.sqlite

figures: my_db.sqlite

paper/stack-overflow.pdf: figures paper/stack-overflow.md paper/stack-overflow.bib
	pandoc paper/stack-overflow.md --biblio paper/stack-overflow.bib --filter pandoc-citeproc -o paper/stack-overflow.pdf

wc: paper/stack-overflow.pdf
	pdftotext paper/stack-overflow.pdf - | wc -w
