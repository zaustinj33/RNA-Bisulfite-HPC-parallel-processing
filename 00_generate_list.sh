#!/bin/bash

# append names of raw BS read files to list.txt for running future scripts

for f in $PWD/raw_data/*BS*
do
        f=${f##*/}
	f=${f%_[0-9].fq.gz}
        echo $f >> prelist.txt
done

# delete every other line (2nd replicates)
sed '2~2d' $PWD/prelist.txt > list.txt

rm prelist.txt
