# RNA-Bisulfite-data-processing
Pipeline to process RNA Bisulfite libraries for downstream analysis. Uses meRanT package

## Initial directory setup:
<PWD>/raw_data

## Contains 4 scripts:

## 0) Generate raw file list.txt
### Input: /raw_data, .fq files | Output: list.txt
Script that will generate list of .fq files that are stored in raw_data

## 1) Submission script
### Input: list.txt, 02_.sbatch | Output: none
Submission script will create a unique sbatch code for each pair of read files and submit to the Slurm HPC

## 2) Excecution script
### Input: Pre-assmbled genome index, GTF, and raw genome file | Output: Cleaned, mapped RNAseq reads
Excecutes multiple software commands to analyze library contents, trim, clean, and map RNAseq files
0) FastQC - raw quality analysis
1) TrimGalore - clean and trim reads
2) FastQC - clean quality analysis
3) meRanT alignment - map reads to transcriptome (can be changed to genome)
4) meRanCall - generates a table of m5C sites per transcript
5) meRanDiff - (not added, unreliable) will generate analysis of differentially methylated sites between samples

## 3) MultiQC
### Input: statitics summaries of FastQC and meRanT | Output: .html report of all analysis
Gathers all relevant data into a new MultiQC folder, and performs analysis of all relevant data
