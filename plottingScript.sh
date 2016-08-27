#!/bin/bash
#A script that displays an image of a plot given a rendered txt file
#(created by codigoFrankSorted.sh)

function usagePrint {
    echo "Usage $0 filename.txt [-c colNumber]"
    echo "Default colNumber is 3, it generates a png file."
    exit 1
}

function optionAndFileCheck {
    [ $# -eq 0 ] && usagePrint
    [ ! -e $1 ] && echo "Error: file $1 does't exist" && return 1
    if [ "$2" = "-c" ]
    then
	[ $# -ne 3 ] && echo "Need colNumber (2, 3 or 4)" && return 2
	if [ $3 -eq 2 ] || [ $3 -eq 3 ] || [ $3 -eq 4 ]
	then
	    return 0
	else
	    echo "Error: colNumber has to be either 2, 3 or 4."
	    return 3
	fi
    fi
    return 0
}

function makeThePlot {
    dFile=$1
    col2Plot=3
    [ $# -eq 3 ] && col2Plot=$3
    pngName=$(basename $dFile .txt)W$col2Plot.png
    #Check if the column was defined
    gnuplot -e "set term pngcairo size 1024,768;\
                set out \"$pngName\";\
                set format y \"%.0s*10^%T\";\
                datafile=\"$dFile\"; stats datafile;\
                plot for [IDX=1:STATS_blocks] datafile i (IDX-1)\
                u (IDX%2?\$1+0.3:\$1-0.3):\
                $col2Plot:(sprintf(\"%d\",IDX))\
                with labels\
                title sprintf(\"%d\",IDX),\
                for [IDX=1:STATS_blocks] datafile i (IDX-1) u 1:$col2Plot\
                with lp title sprintf(\"%d\",IDX)"  2> /dev/null
    #Diplay the plot using eog, make sure it is installed
    eog "$pngName"
    # rm "$pngName"

}

optionAndFileCheck $@ && makeThePlot $@

exit 0

