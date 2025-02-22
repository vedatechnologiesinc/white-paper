#——————————————————————————————————————————————————————————————————————————————
# Head

SHELL := bash
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

#——————————————————————————————————————————————————————————————————————————————
# Body

NAME=white-paper
TEX=$(NAME).tex
ORG=$(NAME).org
PDF=$(NAME).pdf

.PHONY: all clean open

all: $(PDF)

$(PDF): $(TEX)
	xelatex $^
	bibtex $(NAME)
	xelatex $^

$(TEX): $(ORG)
	pandoc -f org -t latex --embed-resources --standalone -o $@ $^

clean:
	rm -f $(NAME)
	rm -f $(BINDIR)/$(NAME)

open: $(PDF)
	open $^
