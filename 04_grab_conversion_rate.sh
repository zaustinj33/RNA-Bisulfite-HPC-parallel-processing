#!/bin/bash
## Grab conversion rate statistic from slurm output files of meRanT ##


#Xiaorans data
#for FILE in /groups/ECBL/RNA_project/mouse_NSC_FA_project/02_RNA_BS_seq/02_mapping_results/ensemble_transcriptome/slurm*

#my data
for FILE in ~/FMR-YBX_RNA_BS/Code/*/slurm* 
do
	result=${FILE%/slurm*} #path without filename
	result="${result%"${result##*[!/]}"}" #trim all trailing /'s
	result="${result##*/}"  #remove all text before last /
	echo -e "$result \t" >> conversion_rates.txt
	grep -E 'Total # of reads|Total # of mapped reads|Total analyzed C to T conversion rate|Total analyzed methylated Cs' $FILE >> conversion_rates.txt
	echo -e "\n" >> conversion_rates.txt
done
