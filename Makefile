DATA_FOLDER = raw
METADATA = munge/keep.json
TABLES = $(shell python munge/tables.py $(METADATA))

my_db.sqlite: munge/xml2sql.py munge/keep.json munge/event-study.R
	cd $(DATA_FOLDER); make all
	python munge/xml2sql.py $(DATA_FOLDER) my_db.sqlite
	cd munge; python badges.py
	R -e "source('munge/event-study.R')"

figures/badges.pdf: figures/event-study.R my_db.sqlite figures/my_poisson.do
	Rscript figures/event-study.R

paper/clean.bib: paper/clean-references.py paper/raw.bib
	python paper/clean-references.py paper/raw.bib > paper/clean.bib

paper/stack-overflow.pdf: paper/clean.bib paper/*.tex
	cd paper; \
	pdflatex stack-overflow; \
	bibtex stack-overflow; \
	pdflatex stack-overflow; \
	pdflatex stack-overflow

wc: paper/stack-overflow.pdf
	pdftotext paper/stack-overflow.pdf - | wc -w
