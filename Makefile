my_db.sqlite: munge/xml2sql.py munge/keep.json $(DATA_FOLDER)/*.xml
	rm -f my_db.sqlite
	python munge/xml2sql.py $(DATA_FOLDER) my_db.sqlite

figures: my_db.sqlite

paper/clean.bib: paper/raw.bib
	cd paper ; python clean-references.py raw.bib clean.bib

paper/stack-overflow.pdf: figures paper/stack-overflow.md paper/clean.bib
	pandoc paper/stack-overflow.md --biblio paper/clean.bib --filter pandoc-citeproc -o paper/stack-overflow.pdf

wc: paper/stack-overflow.pdf
	pdftotext paper/stack-overflow.pdf - | wc -w
