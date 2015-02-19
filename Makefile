DATA_FOLDER = raw
METADATA = munge/keep.json
TABLES = $(shell python munge/tables.py $(METADATA))

my_db.sqlite: munge/xml2sql.py munge/keep.json munge/event-study.R
	cd $(DATA_FOLDER); make all
	python munge/xml2sql.py $(DATA_FOLDER) my_db.sqlite
	cd munge; python badges.py
	R -e "source('munge/event-study.R')"

figures/editing.pdf: figures/event-study.R my_db.sqlite
	Rscript figures/event-study.R

paper/clean.bib: paper/clean-references.py paper/raw.bib
	python paper/clean-references.py paper/raw.bib > paper/clean.bib

paper/stack-overflow.pdf: paper/stack-overflow.md paper/clean.bib
	pandoc paper/stack-overflow.md -V geometry:margin=1in --biblio paper/clean.bib --filter pandoc-citeproc -o paper/stack-overflow.pdf

wc: paper/stack-overflow.pdf
	pdftotext paper/stack-overflow.pdf - | wc -w
