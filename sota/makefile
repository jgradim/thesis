TARGET=sota

all:
	pdflatex $(TARGET).tex
	bibtex $(TARGET)
	pdflatex $(TARGET).tex
	pdflatex $(TARGET).tex

clean:
	rm -f *.aux *.bbl *.blg *.lof *.log *.lot *.out *.toc

rebuild: clean all
