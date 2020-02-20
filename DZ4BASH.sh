#!/bin/bash

# input FILE for analyzing
FILE=/home/rustam3/DZ4_BASH/access-4560-644067.log

# insert timestamps covering FILE
echo "Results covering following timestamps:"
cat $FILE | awk 'NR == 1 {print} END {print}' | awk '{print $4 " " $5}' | awk 'BEGIN{FS="\n"; RS=""} {print $1,$2}'
echo " "

#X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
echo "sourse IPs"
cat $FILE | awk '/GET/ || /POST/ { ipcount[$1]++ } END {for (i in ipcount) { printf "IP:%1s - %d times\n", i, ipcount[i] } }' | sort -k 3 -n
echo " "

#Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
echo "target IPs"
cat $FILE | grep -o 'https*://[^"]*' | awk -F"/" '{print $3}' | sed 's/www./bar/' | sed 's/)$//' | awk '{ ipcount[$1]++ } END {for (i in ipcount) { printf "IP:%1s - %d times\n", i, ipcount[i] } }' | sort -k 3 -n
echo " "

#все ошибки c момента последнего запуска
#список всех кодов возврата с указанием их кол-ва с момента последнего запуска
echo "type & number erros:"
cat $FILE  | awk -F"\"" '{print $3}' | awk '{print $1}' | awk '/4../ || /5../ { error[$1]++ } END {for (i in error) { printf "errorID:%1s - %d times\n", i, error[i] } }' | sort -k 3 -n
