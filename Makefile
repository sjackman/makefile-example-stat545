# Compare word lengths of English and French

all: en.html fr.html

en.crlf.txt:
	curl http://www-01.sil.org/linguistics/wordlists/english/wordlist/wordsEn.txt >en.crlf.txt

en.txt: en.crlf.txt
	tr -d '\r' <en.crlf.txt >en.txt

fr.txt:
	curl https://raw.githubusercontent.com/atebits/Words/master/Words/fr.txt >fr.txt
	
%.length: %.txt
	awk '{print length}' $*.txt >$*.length

%.length.count: %.length
	sort -n $*.length | uniq -c >$*.length.count

%.tsv: %.length.count
	awk 'BEGIN {printf "Length\tCount\n"} {print $$2 "\t" $$1}' $*.length.count >$*.tsv

%.html: %.rmd %.tsv
	Rscript -e 'rmarkdown::render("$*.rmd")'
