#!/bin/bash
#busca columnas importantes (1,4,7,11) del archivo y guarda en txt
#dejando las cosas listas para plotear. (Ver también plottingScript.sh)

a=$(find . -type f -regex ".*\.txt$")

# [ "$a" != "" ] && rm *.txt && echo "removing all txt's"

function createInitialTxts {
    for i in `ls *.fsires | sort -V` #Important to sort
    do
	echo "Processing $i"
	#Super important getting rid of the \r (carriage return)
	base=$(grep "Sample Id " $i | cut -d: -f 2| tr -d '\r'\
		      | tr -d ' ')

	txtName=$base.txt

	baseI=$(basename $i .fsires)

	echo "Appending to $txtName"
	#Creating file in case it does not exist
	newlineVal="\n\n"
	[ ! -f $txtName ] && touch $txtName && newlineVal=""
	echo -e "$newlineVal#$baseI" >> $txtName
	awk '/^[[:digit:]]+[[:space:]]+[[:digit:]]+/ {print $0;}' $i \
	    | cut -d' ' -f1,4,7,11>> $txtName
    done 
}

function createAveTxts {
    for i in C*.txt
    do
	avFilename="ave$i"
	echo "Creating the average file for $i named $avFilename"
	python3 createAveTxts.py -i $i > $avFilename
    done
}

createInitialTxts
createAveTxts

exit 0

