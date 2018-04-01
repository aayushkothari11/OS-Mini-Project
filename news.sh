#!/bin/bash

touch fetchedPage
rm fetchedPage
wget -O fetchedPage https://timesofindia.indiatimes.com/

declare -a ARRAY
fileName="fetchedPage"

exec 10<&0
exec < $fileName

let count=0
while read LINE; do
	ARRAY[$count]=$LINE
	((count++))
done

exec 0<&10 10<&-

regex="<a pg=\"new[[:print:]]*<\/a>"

ELEMENTS=${#ARRAY[@]}
firstLine=0
for ((i=0;i<$ELEMENTS;i++)); do
	if [[ ${ARRAY[${i}]} =~ $regex ]]; then
		if [[ $firstLine<1 ]] ; then
			echo ${BASH_REMATCH[0]} > news
			let firstLine=$firstLine+1
		else
			echo ${BASH_REMATCH[0]} >> news
		fi

	fi
done

declare -a ARRAY2
fileName="news"

exec 10<&0
exec < $fileName

let count2=0
while read LINE; do
	ARRAY2[$count2]=$LINE
	((count2++))
done

exec 0<&10 10<&-

regex="title=\"[-%0-9a-zA-Z\-\'\:\.\?\,\;\%\& ]+\""

ELEMENTS=${#ARRAY2[@]}
firstLine=0
for ((i=0;i<$ELEMENTS;i++)); do
	if [[ ${ARRAY2[${i}]} =~ $regex ]]; then
		if [[ $firstLine<1 ]] ; then
			echo ${BASH_REMATCH[0]#title=} > news
			let firstLine=$firstLine+1
		else
			echo ${BASH_REMATCH[0]#title=} >> news
		fi

	fi
done
