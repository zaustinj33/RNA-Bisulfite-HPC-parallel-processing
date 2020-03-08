## MultiQC execution ##

# Copy all relevant files to a MultiQC folder
find . -name '*.html' | cpio -updm ~/RNA_BSnew/MultiQC_files/

# Run MultiQC
cd ~/RNA_BSnew/MultiQC
multiqc .
