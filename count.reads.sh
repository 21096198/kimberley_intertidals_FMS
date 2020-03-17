#!/bin/bash

for i in *.txt.gz
do
zcat $i | grep "@" | wc -l >> reads.per.sample.txt
done
