#!/bin/bash

set -ex

# Download file
[ ! -f 1.txt ] && curl -o 1.txt http://esodata.uesp.net/current/globals.txt

# Cut off indented lines
grep -v "^\s" 1.txt > 2.txt

# Cut off private functions
grep -v "function: Private" 2.txt > 3.txt

# Move tokens to a new fie, parsing the name and type
awk '$3=/table:/ ? $1 ", table" : $0' 3.txt > 4.txt
awk '$3=/userdata:/ ? $1 ", userdata" : $0' 4.txt > 5.txt
awk '$3=/function:/ ? $1 ", function" : $0' 5.txt > 6.txt
awk '$3=/true|false/ ? $1 ", bool" : $0' 6.txt > 7.txt
awk '$3=/-?[0-9\.]+/ ? $1 ", integer" : $0' 7.txt > 8.txt
awk '{ print $1 ", string" }' 8.txt > 9.txt

# Sort and remove duplicates
sort -u 9.txt > 10.txt

# Split alphabetically (make it two parts to avoid `too many open files`)
# awk '/^[A-Ma-m]/ { file=tolower(substr($1, 1, 1))".txt"; print $0 > file }' 10.txt
# awk '/^[N-Zn-z]/ { file=tolower(substr($1, 1, 1))".txt"; print $0 > file }' 10.txt

mv 10.txt tokens.txt

# Delete temporary files
rm 1.txt 2.txt 3.txt 4.txt 5.txt 6.txt 7.txt 8.txt 9.txt 
