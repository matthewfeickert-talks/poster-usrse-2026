FILENAME = poster

date = $(shell date +%Y-%m-%d)
output_file = draft_$(date).pdf

figure_src = $(wildcard figures/*.svg figures/*/*.svg)
figure_list = $(figure_src:.svg=.pdf)

LATEX = lualatex

BIBTEX = bibtex

default: poster

figures: $(figure_list)

# Target assumes figure source is in same directory as expected figure path
# Inkscape 1.x command line options, cf. https://inkscape.org/doc/inkscape-man.html
figures/%.pdf: figures/%.svg
	inkscape --export-area-drawing --export-type=pdf --export-filename=$@ $<

# Emoji keep their full page instead of being cropped to the drawing, as the
# \emoji command in poster.tex sizes them by the padded Noto Emoji page.
# GNU Make uses this rule over the one above as it has the shorter stem.
figures/emoji_u%.pdf: figures/emoji_u%.svg
	inkscape --export-type=pdf --export-filename=$@ $<

poster: figures
	latexmk -$(LATEX) -logfilewarnings -halt-on-error $(FILENAME)
	rsync $(FILENAME).pdf $(output_file)
	rsync $(FILENAME).pdf feickert_usrse_2026.pdf

clean:
	rm -f *.aux *.bbl *.blg *.dvi *.idx *.lof *.log *.lot *.toc \
		*.xdy *.nav *.out *.snm *.vrb *.mp \
		*.synctex.gz *.brf *.fls *.fdb_latexmk \
		*.glg *.gls *.glo *.ist *.alg *.acr *.acn

clean_drafts:
	rm -f draft_*.pdf

realclean: clean
	rm -f *.ps *.pdf
