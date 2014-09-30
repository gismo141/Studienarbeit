SOURCE_FOLDER	:= Kapitel
BUILD_FOLDER	:= .build
FILE			:= Studienarbeit
TEMPLATE 		:= template.latex
BIBLIOGRAPHY 	:= ../../configuration/Bibtex/library.bib

all: pandoc
	cd $(BUILD_FOLDER) && latexmk -pdf -shell-escape $(FILE).tex && cp $(FILE).pdf .. && open ../$(FILE).pdf

pandoc: before
	cd $(BUILD_FOLDER) && pandoc -s -N --template=$(TEMPLATE) --bibliography=$(BIBLIOGRAPHY) --biblatex --listings --toc -f markdown+raw_tex+grid_tables --chapters ../$(SOURCE_FOLDER)/*.md -o $(FILE).tex

before:
	mkdir -p $(BUILD_FOLDER)

clean:
	rm -rf $(BUILD_FOLDER)