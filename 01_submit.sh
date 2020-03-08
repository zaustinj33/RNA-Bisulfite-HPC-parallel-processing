#!/bin/bash

# Usage: bash 01_submit.sh <File with list of data> <Absolute path to directory>

cat $1 | while read LINE
do
	sh ./02_RNA_BS_trans_final_ZJ.sh $LINE $2
done
