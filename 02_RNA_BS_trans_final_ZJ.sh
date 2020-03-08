#!/bin/bash

mkdir -p $2/Code
mkdir -p $2/result
mkdir -p $2/Code/$1
mkdir -p $2/result/$1
mkdir -p $2/working_data
mkdir -p $2/working_data/$1

IDXdir=/groups/ECBL/RNA_project/mouse_NSC_FA_project/02_RNA_BS_seq/05_Index/mm10_ensemble_79

pushd $2/Code/$1

echo -e "#!/bin/bash
#SBATCH -p --
#SBATCH -A --
#SBATCH --nodes=1 --ntasks-per-node=16
#SBATCH --exclusive
#SBATCH --time=100:00:00
#SBATCH --mail-user zaustinj@vt.edu
#SBATCH --mail-type=END
" >> $1_map_trans.sbatch

echo -e "module add FastQC/0.11.7-Java-1.8.0_162\nmodule add Trim_Galore/0.5.0-foss-2018a cutadapt/1.17-foss-2018a-Python-3.6.4\n" >> $1_map_trans.sbatch 

echo -e "cd $2/raw_data/$1 \n" >> $1_map_trans.sbatch
echo -e "echo 'unzipping data'" >> $1_map_trans.sbatch
echo -e "gzip -d $1_1.fq.gz" >> $1_map_trans.sbatch
echo -e "gzip -d $1_2.fq.gz" >> $1_map_trans.sbatch

echo -e "echo "Starting FastQC"
fastqc $2/raw_data/$1/$1_1.fq
fastqc $2/raw_data/$1/$1_2.fq
echo "Finished FastQC""\n >> $1_map_trans.sbatch
 
echo -e "mv *fast* $2/working_data/$1/\n" >> $1_map_trans.sbatch

echo -e "echo "Starting trim_galore"
trim_galore --paired --phred33 --fastqc --illumina --clip_R1 6 --clip_R2 6 --dont_gzip -q 30 --length 30 $2/raw_data/$1/$1_1.fq $2/raw_data/$1/$1_2.fq --output_dir $2/working_data/$1
echo "Finished trim_galore""\n >> $1_map_trans.sbatch

echo -e "cd $2/working_data/$1\n" >> $1_map_trans.sbatch 

echo -e "echo 'Starting meRanT'
meRanT align -o $2/result/$1 -f $1_1_val_1.fq -r $1_2_val_2.fq -t 20 -k 10 -S $1_trans79.sam -ds -ra -MM -fmo -mmr 0.01 -i2g $IDXdir/mouse.rna.ensemble.map -x $IDXdir/Mus_musculus.GRCm38.all.RNA.format_C2T
echo 'Finished meRanT'" >> $1_map_trans.sbatch

echo -e "echo 'Starting meRanCall'
meRanCall -p 16 -o $2/result/$1/$1_m5c_site_trans.txt -bam $2/result/$1/$1_trans79_sorted.bam -f $IDXdir/Mus_musculus.GRCm38.all.RNA.format.fa -rl 150 -sc 10 -md 1 -ei 0.1 -cr 0.99 -fdr 0.01 -mr 0.1 -mcov 20 -tref
echo 'Finished meRanCall'" >> $1_map_trans.sbatch


echo -e "echo 'finished'\n" >> $1_map_trans.sbatch

sbatch $1_map_trans.sbatch
