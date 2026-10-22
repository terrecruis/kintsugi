PDF = main.pdf
SRC = main.tex $(wildcard config/*.tex frontmatter/*.tex chapters/*.tex chapters/decisioni/*.tex appendices/*.tex)

all: $(PDF)

$(PDF): $(SRC)
	latexmk -pdf -interaction=nonstopmode -halt-on-error main.tex

clean:
	latexmk -C

.PHONY: all clean
