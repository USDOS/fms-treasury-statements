#!/bin/sh

# Run this on a file like 12121400.txt
datestamp=$(echo "$1"|sed 's/\.txt$//')
mkdir -p datestamp

# Pick out fixie files for the different tables.
sed -n '15,19 p' $datestamp.txt > $datestamp/table1.fixie
sed -n -e '34,67 p' -e '78,123 p' $datestamp.txt > $datestamp/table2.fixie
sed -n -e '137,155 p' -e '164,178 p' $datestamp.txt > $datestamp/table3a.fixie
sed -n '192,214 p' $datestamp.txt > $datestamp/table3b.fixie
sed -n '230,245 p' $datestamp.txt > $datestamp/table3c.fixie
sed -n '264,277 p' $datestamp.txt > $datestamp/table4.fixie
sed -n '286,298 p' $datestamp.txt > $datestamp/table5.fixie
sed -n '312,315 p' $datestamp.txt > $datestamp/table6.fixie
