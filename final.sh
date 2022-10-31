#!/bin/bash
#Now I am in the main directory and creat ICA file
mkdir ICA1
cp -r /localdisk/data/BPSM/ICA1/fastq/ ~/ICA1/
cp /localdisk/data/BPSM/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed ~/ICA1/

#for assessment
cd ICA1
mkdir fastqcoutput
cd fastq
fastqc *.fq.gz -o ~/ICA1/fastqcoutput

unzip "~/ICA1/fastqcoutput/*zip"
count=0
cat Tco.fqfiles | while read LINE
do
	if (($count > 0));then
		QC1=$(grep -c "PASS" ~/ICA1/fastqcoutput/"${LINE:start:3}-${LINE:3:4}_1_fastqc"/summary.txt)
		if (({$QC1}>7));then
		echo "$SampleName_1 is a good data"
		fi
		QC2=$(grep -c "PASS" ~/ICA1/fastqcoutput/"${LINE:start:3}-${LINE:3:4}_2_fastqc"/summary.txt)
		if (({$QC2}>7));then
		echo "$SampleName_2 is a good data"
		fi
	fi
count=$[ $count + 1]
done

#using bowtie2 and samtools, I can get some bed files for creating count files
bowtie2-build "/localdisk/data/BPSM/ICA1/Tcongo_genome/TriTrypDB-46_TcongolenseIL3000_2019_Genome.fasta.gz" index
gunzip *gz
count=1
cat Tco.fqfiles | while read SampleName SampleType Replicate Time Treatment End1 End2
do
	if (($count > 1));then
		echo $SampleName $End1 $End2 >>result
		sed -i 's/.gz//g' result
	fi
	count=$[ $count + 1]
done

cat result | while read Sam E1 E2
do
bowtie2 -p 10 -x ~/ICA1/fastq/index -1 ~/ICA1/fastq/"$E1" -2 ~/ICA1/fastq/"$E2" | samtools sort -O bam -o - > "$Sam.bam"
bedtools coverage -a ~/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed -b "$Sam.bam" > "$Sam.bed" 
done

#according type, time, and treatment, I can have many groups
mkdir Clone1-0-Un Clone1-0-In Clone1-24-Un Clone1-24-In Clone1-48-Un Clone1-48-In
count=1
cat Tco.fqfiles | while read SampleName SampleType Replicate Time Treatment End1 End2
do
	if (($count > 1));then
		echo $SampleName $SampleType $Time $Treatment >> result1
	fi
	count=$[ $count + 1]
done

count=1
cat result1 | while read SampleName SampleType Time Treatment
do
  if (($count > 0));then
  	if [[ "$SampleType" == "Clone1" && "$Time" == "0" ]]  ;then
	  	if [[ $Treatment == "Uninduced" ]];then
		  	cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/Clone1-0-Un/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/Clone1-0-Un/genename 
		  else
   	    		cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/Clone1-0-In/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/Clone1-0-In/genename
		  fi
    	fi
   fi
  count=$[ $count + 1]
done

count=1
cat result1 | while read SampleName SampleType Time Treatment
do
  if (($count > 0));then
        if [[ "$SampleType" == "Clone1" && "$Time" == "24" ]]  ;then
                if [[ $Treatment == "Uninduced" ]];then
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/Clone1-24-Un/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/Clone1-24-Un/genename
                  else
            		cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/Clone1-24-In/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/Clone1-24-In/genename
                  fi
    fi
        fi
  count=$[ $count + 1]
done

count=1
cat result1 | while read SampleName SampleType Time Treatment
do
  if (($count > 0));then
        if [[ "$SampleType" == "Clone1" && "$Time" == "48" ]]  ;then
                if [[ $Treatment == "Uninduced" ]];then
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/Clone1-48-Un/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/Clone1-48-Un/genename
                  else
            		cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/Clone1-48-In/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/Clone1-48-In/genename
                  fi
    fi
        fi
  count=$[ $count + 1]
done

mkdir Clone2-0-Un Clone2-0-In Clone2-24-Un Clone2-24-In Clone2-48-Un Clone2-48-In
count=1
cat result1 | while read SampleName SampleType Time Treatment
do
  if (($count > 0));then
        if [[ "$SampleType" == "Clone2" && "$Time" == "0" ]]  ;then
                if [[ $Treatment == "Uninduced" ]];then
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/Clone2-0-Un/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/Clone2-0-Un/genename
                  else
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/Clone2-0-In/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/Clone2-0-In/genename
                  fi
        fi
   fi
  count=$[ $count + 1]
done

count=1
cat result1 | while read SampleName SampleType Time Treatment
do
  if (($count > 0));then
        if [[ "$SampleType" == "Clone2" && "$Time" == "24" ]]  ;then
                if [[ $Treatment == "Uninduced" ]];then
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/Clone2-24-Un/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/Clone2-24-Un/genename
                  else
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/Clone2-24-In/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/Clone2-24-In/genename
                  fi
    fi
        fi
  count=$[ $count + 1]
done

count=1
cat result1 | while read SampleName SampleType Time Treatment
do
  if (($count > 0));then
        if [[ "$SampleType" == "Clone2" && "$Time" == "48" ]]  ;then
                if [[ $Treatment == "Uninduced" ]];then
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/Clone2-48-Un/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/Clone2-48-Un/genename
                  else
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/Clone2-48-In/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/Clone2-48-In/genename
                  fi
    fi
        fi
  count=$[ $count + 1]
done

mkdir WT-0-Un WT-0-In WT-24-Un WT-24-In WT-48-Un WT-48-In
count=1
cat result1 | while read SampleName SampleType Time Treatment
do
  if (($count > 0));then
        if [[ "$SampleType" == "WT" && "$Time" == "0" ]]  ;then
                if [[ $Treatment == "Uninduced" ]];then
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/WT-0-Un/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/WT-0-Un/genename
			
                  else
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/WT-0-In/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/WT-0-In/genename
                  fi
        fi
   fi
  count=$[ $count + 1]
done

count=1
cat result1 | while read SampleName SampleType Time Treatment
do
  if (($count > 0));then
        if [[ "$SampleType" == "WT" && "$Time" == "24" ]]  ;then
                if [[ $Treatment == "Uninduced" ]];then
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/WT-24-Un/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/WT-24-Un/genename
                  else
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/WT-24-In/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/WT-24-In/genename
                  fi
    fi
        fi
  count=$[ $count + 1]
done

count=1
cat result1 | while read SampleName SampleType Time Treatment
do
  if (($count > 0));then
        if [[ "$SampleType" == "WT" && "$Time" == "48" ]]  ;then
                if [[ $Treatment == "Uninduced" ]];then
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/WT-48-Un/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/WT-48-Un/genename
                  else
                        cp /home/s2146761/ICA1/fastq/$SampleName.bed /home/s2146761/ICA1/fastq/WT-48-In/
			echo "$SampleName.bed" >> /home/s2146761/ICA1/fastq/WT-48-In/genename
                  fi
    fi
        fi
  count=$[ $count + 1]
done

#to extract data and get the mean account of the per gene
count=1
for i in `find ~/ICA1/fastq/ -type d`
do
cat $i/"genename" | while read LINE
do
	if (($count > 0));then
	cut -f 6 $i/"$LINE" > $i/"$LINE.txt"
   	fi
	count=$[ $count + 1]
done
paste $i/*.txt > $i/123.txt
done

count=1
for q in `find ~/ICA1/fastq/ -type d`
do
awk 'BEGIN{ sum = 0 } {for(i = 1; i <= NF; i++) {sum += $i} {print sum/NF; sum =0}}' $q/123.txt >> $q/average.txt
paste /home/s2146761/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed $q/123.txt $q/average.txt > $q/expression.txt
done

#process the 'group-wise' comparison by if these samples are induced
paste /home/s2146761/ICA1/fastq/WT-24-Un/average.txt /home/s2146761/ICA1/fastq/WT-24-In/average.txt >> /home/s2146761/ICA1/fastq/WT-24-Un/group
awk '{print ($1+1)/($2+1)}' /home/s2146761/ICA1/fastq/WT-24-Un/group >> /home/s2146761/ICA1/fastq/WT-24-Un/group1
paste /home/s2146761/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed /home/s2146761/ICA1/fastq/WT-24-Un/group1 >> /home/s2146761/ICA1/fastq/WT-24-Un/fold |sort -k 6 -n -r

paste /home/s2146761/ICA1/fastq/WT-24-In/average.txt /home/s2146761/ICA1/fastq/WT-24-Un/average.txt >> /home/s2146761/ICA1/fastq/WT-24-In/group
awk '{print ($1+1)/($2+1)}' /home/s2146761/ICA1/fastq/WT-24-In/group >> /home/s2146761/ICA1/fastq/WT-24-In/group1
paste /home/s2146761/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed /home/s2146761/ICA1/fastq/WT-24-In/group1 >> /home/s2146761/ICA1/fastq/WT-24-In/fold |sort -k 6 -n -r

paste /home/s2146761/ICA1/fastq/WT-48-Un/average.txt /home/s2146761/ICA1/fastq/WT-48-In/average.txt >> /home/s2146761/ICA1/fastq/WT-48-Un/group
awk '{print ($1+1)/($2+1)}' /home/s2146761/ICA1/fastq/WT-48-Un/group >> /home/s2146761/ICA1/fastq/WT-48-Un/group1
paste /home/s2146761/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed /home/s2146761/ICA1/fastq/WT-48-Un/group1 >> /home/s2146761/ICA1/fastq/WT-48-Un/fold |sort -k 6 -n -r

paste /home/s2146761/ICA1/fastq/WT-48-In/average.txt /home/s2146761/ICA1/fastq/WT-48-Un/average.txt >> /home/s2146761/ICA1/fastq/WT-48-In/group
awk '{print ($1+1)/($2+1)}' /home/s2146761/ICA1/fastq/WT-48-In/group >> /home/s2146761/ICA1/fastq/WT-48-In/group1
paste /home/s2146761/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed /home/s2146761/ICA1/fastq/WT-48-In/group1 >> /home/s2146761/ICA1/fastq/WT-48-In/fold |sort -k 6 -n -r

paste /home/s2146761/ICA1/fastq/Clone1-24-Un/average.txt /home/s2146761/ICA1/fastq/Clone1-24-In/average.txt >> /home/s2146761/ICA1/fastq/Clone1-24-Un/group
awk '{print ($1+1)/($2+1)}'  /home/s2146761/ICA1/fastq/Clone1-24-Un/group >> /home/s2146761/ICA1/fastq/Clone1-24-Un/group1
paste /home/s2146761/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed /home/s2146761/ICA1/fastq/Clone1-24-Un/group1 >> /home/s2146761/ICA1/fastq/Clone1-24-Un/fold |sort -k 6 -n -r

paste /home/s2146761/ICA1/fastq/Clone1-24-In/average.txt /home/s2146761/ICA1/fastq/Clone1-24-Un/average.txt >> /home/s2146761/ICA1/fastq/Clone1-24-In/group
awk '{print ($1+1)/($2+1)}' /home/s2146761/ICA1/fastq/Clone1-24-In/group >> /home/s2146761/ICA1/fastq/Clone1-24-In/group1
paste /home/s2146761/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed /home/s2146761/ICA1/fastq/Clone1-24-In/group1 >> /home/s2146761/ICA1/fastq/Clone1-24-In/fold |sort -k 6 -n -r

paste /home/s2146761/ICA1/fastq/Clone1-48-Un/average.txt /home/s2146761/ICA1/fastq/Clone1-48-In/average.txt >> /home/s2146761/ICA1/fastq/Clone1-48-Un/group
awk '{print ($1+1)/($2+1)}' /home/s2146761/ICA1/fastq/Clone1-48-Un/group >> /home/s2146761/ICA1/fastq/Clone1-48-Un/group1
paste /home/s2146761/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed /home/s2146761/ICA1/fastq/Clone1-48-Un/group1 >> /home/s2146761/ICA1/fastq/Clone1-48-Un/fold |sort -k 6 -n -r

paste /home/s2146761/ICA1/fastq/Clone1-48-In/average.txt /home/s2146761/ICA1/fastq/Clone1-48-Un/average.txt >> /home/s2146761/ICA1/fastq/Clone1-48-In/group
awk '{print ($1+1)/($2+1)}' /home/s2146761/ICA1/fastq/Clone1-48-In/group >> /home/s2146761/ICA1/fastq/Clone1-48-In/group1
paste /home/s2146761/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed /home/s2146761/ICA1/fastq/Clone1-48-In/group1 >> /home/s2146761/ICA1/fastq/Clone1-48-In/fold |sort -k 6 -n -r

paste /home/s2146761/ICA1/fastq/Clone2-24-Un/average.txt /home/s2146761/ICA1/fastq/Clone2-24-In/average.txt >> /home/s2146761/ICA1/fastq/Clone2-24-Un/group
awk '{print ($1+1)/($2+1)}' /home/s2146761/ICA1/fastq/Clone2-24-Un/group >> /home/s2146761/ICA1/fastq/Clone2-24-Un/group1
paste /home/s2146761/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed /home/s2146761/ICA1/fastq/Clone2-24-Un/group1 >> /home/s2146761/ICA1/fastq/Clone2-24-Un/fold |sort -k 6 -n -r
paste /home/s2146761/ICA1/fastq/Clone2-24-In/average.txt /home/s2146761/ICA1/fastq/Clone2-24-Un/average.txt >> /home/s2146761/ICA1/fastq/Clone2-24-In/group
awk '{print ($1+1)/($2+1)}' /home/s2146761/ICA1/fastq/Clone2-24-In/group >> /home/s2146761/ICA1/fastq/Clone2-24-In/group1
paste /home/s2146761/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed /home/s2146761/ICA1/fastq/Clone2-24-In/group1 >> /home/s2146761/ICA1/fastq/Clone2-24-In/fold |sort -k 6 -n -r

paste /home/s2146761/ICA1/fastq/Clone2-48-Un/average.txt /home/s2146761/ICA1/fastq/Clone2-48-In/average.txt >> /home/s2146761/ICA1/fastq/Clone2-48-Un/group
awk '{print ($1+1)/($2+1)}' /home/s2146761/ICA1/fastq/Clone2-48-Un/group >> /home/s2146761/ICA1/fastq/Clone2-48-Un/group1
paste /home/s2146761/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed /home/s2146761/ICA1/fastq/Clone2-48-Un/group1 >> /home/s2146761/ICA1/fastq/Clone2-48-Un/fold |sort -k 6 -n -r

paste /home/s2146761/ICA1/fastq/Clone2-48-In/average.txt /home/s2146761/ICA1/fastq/Clone2-48-Un/average.txt >> /home/s2146761/ICA1/fastq/Clone2-48-In/group
awk '{print ($1+1)/($2+1)}' /home/s2146761/ICA1/fastq/Clone2-48-In/group >> /home/s2146761/ICA1/fastq/Clone2-48-In/group1
paste /home/s2146761/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed /home/s2146761/ICA1/fastq/Clone2-48-In/group1 >> /home/s2146761/ICA1/fastq/Clone2-48-In/fold |sort -k 6 -n -r
