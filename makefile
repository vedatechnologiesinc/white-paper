#———————————————————————————————————————————————————————————————————————————————
# HEAD
MAIN = white-paper
BIB = references.bib
SED = sed
LATEX = xelatex
BIBTEX = bibtex
EMACS = emacs
TEXSRC = $(MAIN).tex
ORGSRC = $(MAIN).org
MINTED=_minted
LATEXFLAGS = -interaction=nonstopmode -shell-escape

#———————————————————————————————————————————————————————————————————————————————
# BODY
.PHONY: all cleanall clean org-to-tex

org-to-tex: $(ORGSRC)
	@echo "Converting $(ORGSRC) to $(TEXSRC)..."
	@$(EMACS) --batch \
		--eval "(require 'ox-latex)" \
		--eval "(setq org-latex-listings 'minted \
				org-latex-packages-alist '((\"\" \"minted\")) \
				org-latex-pdf-process '(\"pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f\"))" \
		--eval "(with-current-buffer (find-file \"$(ORGSRC)\") \
				(org-latex-export-to-latex))"

clean-tex: $(TEXSRC)
	@echo "Fixing Final TeX file cleanups"
	@echo "Delete the redundant reference to the bibliography..."
	@$(SED) -i '/\\addbibresource{.*\/references.bib}/d' $(TEXSRC)
	@echo "Down-casing the ABSTRACT word..."
	@$(SED) -i 's/\\begin{ABSTRACT}/\\begin{abstract}/g' $(TEXSRC)
	@$(SED) -i 's/\\end{ABSTRACT}/\\end{abstract}/g' $(TEXSRC)

all: $(MAIN).pdf

$(MAIN).pdf: $(TEXSRC) $(BIB)
	@echo "First init"
	$(LATEX) $(LATEXFLAGS) $(MAIN) || true

	@echo "Running BibTeX"
	@if [ -f $(BIB) ]; then \
		$(BIBTEX) $(MAIN) || true; \
	fi

	@echo "Second init"
	$(LATEX) $(LATEXFLAGS) $(MAIN) || true

	@if [ -f $(MAIN).pdf ]; then \
		echo "Success: PDF file has been created."; \
		rm -f $(MAIN).aux $(MAIN).log $(MAIN).bbl $(MAIN)-blx.bib \
			  $(MAIN).blg $(MAIN).out $(MAIN).bcf $(MAIN).run.xml; \
	fi

cleanall: clean
	rm -f $(MAIN).pdf
	rm -rf $(MINTED)
	rm -f $(MAIN).tex

clean:
	rm -f $(MAIN).aux $(MAIN).log $(MAIN).bbl $(MAIN)-blx.bib \
		$(MAIN).blg $(MAIN).out $(MAIN).bcf $(MAIN).run.xml
