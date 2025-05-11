#!/bin/bash

. ./scripts/helpers/functions.sh --source-only
. ./scripts/helpers/variables.sh --source-only

out_info_pr() {
	out_file_name=(
		"./config/explantion_krnt.txt"
		"./config/explantion_rpzt.txt"
	)
	clear
	for file_name in "${out_file_name[@]}";do
		while IFS= read -r line;do
			style "$line" $yellow
		done < "$file_name"
		if [ "$file_name" != "${out_file_name[-1]}" ];then
			style "Нажмите enter чтоб перелестнуть страницу!" $blue n
		else
			style "Нажмите enter чтоб закончить просмотр!" $blue n
		fi
		read
		clear
	done
}
