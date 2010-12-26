TARGET=thesis

all:
	pdflatex $(TARGET).tex
	bibtex $(TARGET)
	pdflatex $(TARGET).tex
	pdflatex $(TARGET).tex
	pdflatex $(TARGET).tex

clean:
	rm -f *.aux **/*.aux *.bbl *.blg *.lof *.log *.lot *.out *.toc dia/*~

rebuild: clean all
