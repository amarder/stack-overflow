my_db.sqlite: munge/xml2sql.py munge/keep.json $(DATA_FOLDER)/*.xml
	python munge/xml2sql.py $(DATA_FOLDER) my_db.sqlite

figures: my_db.sqlite

figures/event-study.pdf: figures/event-study.R my_db.sqlite
	Rscript figures/event-study.R

paper/clean.bib: paper/clean-references.py paper/raw.bib
	python paper/clean-references.py paper/raw.bib paper/clean.bib

paper/stack-overflow.pdf: figures paper/stack-overflow.md paper/clean.bib figures/event-study.pdf
	# -V classoption:twocolumn
	pandoc paper/stack-overflow.md -V geometry:margin=1in --biblio paper/clean.bib --filter pandoc-citeproc -o paper/stack-overflow.pdf

wc: paper/stack-overflow.pdf
	pdftotext paper/stack-overflow.pdf - | wc -w
