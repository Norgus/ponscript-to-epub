#!/usr/bin/awk -f
# 
# Retrieves script names from flow.txt to compile the runfile
#
# pass flow.txt and metadata.txt as arguments:
# awk -f prettify_commandgen.awk flow.txt metadata.txt
BEGIN {
	runfile = "prettify_run.sh"
	print "unzip book-template.zip" > runfile
	ORS = " "
	print "awk -f prettify.awk " > runfile
}

BEGINFILE{
	if (tolower(FILENAME) ~ /metadata/){
		FS = "\t"
	} else {
		FS = "\""
	}
}

{
	if (tolower(FILENAME) ~ /metadata/){
		if ($1 == "Title"){title = $2}
		if ($1 == "Title file as"){titlefa = $2}
		if ($1 == "Author"){author = $2}
		if ($1 == "Author file as"){authorfa = $2}
		if ($1 == "Modified"){modified = $2}
		if ($1 == "Unique ID"){uniqueid = $2}
		if ($1 == "Ebook filename"){ebookname = $2}
	}
}

/CallScript/{
	print $2 ".txt" > runfile
}

END {
	print "*tips*txt" > runfile
	ORS = "\n"
	print "" > runfile
	print "sed -i -e 's/TITLE HERE/" title "/g' book-template/item/standard.opf book-template/item/xhtml/*" > runfile
	print "sed -i -e 's/TITLE FILEAS HERE/" titlefa "/g' book-template/item/standard.opf" > runfile
	print "sed -i -e 's/AUTHOR HERE/" author "/g' book-template/item/standard.opf book-template/item/xhtml/*" > runfile
	print "sed -i -e 's/AUTHOR FILEAS HERE/" authorfa "/g' book-template/item/standard.opf" > runfile
	print "sed -i -e 's/UNIQUE ID HERE/" uniqueid "/g' book-template/item/standard.opf" > runfile
	print "sed -i -e 's/MODIFIED HERE/" modified "/g' book-template/item/standard.opf" > runfile
	print "sed -i -e '/INSERT HERE/r book-template/item/navigation-documents.txt' -e '/INSERT HERE/d' book-template/item/navigation-documents.xhtml" > runfile
	print "rm book-template/item/navigation-documents.txt" > runfile
	print "sed -i -e '/INSERT HERE/r book-template/item/xhtml/p-toc.txt' -e '/INSERT HERE/d' book-template/item/xhtml/p-toc.xhtml" > runfile
	print "rm book-template/item/xhtml/p-toc.txt" > runfile
	print  "sed -i -e '/INSERT HERE/r book-template/item/xhtml/p-001.txt' -e '/INSERT HERE/d' book-template/item/xhtml/p-001.xhtml" > runfile
	print "rm book-template/item/xhtml/p-001.txt" > runfile
	print  "sed -i -e '/INSERT HERE/r book-template/item/xhtml/tips.txt' -e '/INSERT HERE/d' book-template/item/xhtml/tips.xhtml" > runfile
	print "rm book-template/item/xhtml/tips.txt" > runfile
	print "cd book-template\nzip -X0 ../" ebookname " mimetype\nzip -Xr ../" ebookname " *" > runfile
	system("chmod +x " runfile)
}
