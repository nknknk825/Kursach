#!/bin/bash

. ./scripts/helpers/functions.sh --source-only
. ./scripts/helpers/variables.sh --source-only

out_info_pr() {
	out_file_name=(
		"./config/explantion_krnt.txt"
		"./config/explantion_rpzt.txt"
	)
	clear
	# Вывод пояснений к водимым параметрам программы
	for file_name in "${out_file_name[@]}";do
		while IFS= read -r line;do
			echo "$line"
		done < "$file_name"
		if [ "$file_name" != "${out_file_name[-1]}" ];then
			echo -ne "Нажмите enter чтоб перелестнуть страницу!"
		else
			echo -ne "Нажмите enter чтоб закончить просмотр!"
		fi
		read
		clear
	done
}
