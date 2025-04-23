#!/bin/sh


out_file() {
	var_file=(
		"./data/massiv_t.txt"
		"./data/massiv_Uvx.txt"
		"./data/massiv_Uvix.txt")

	for i in "${!t[@]}";do
		if [ "$i" == "0" ];then
			echo "${t[$i]}" > ${var_file[0]}
			echo "${Uvx[$i]}" > ${var_file[1]}
			echo "${Uvix[$i]}" > ${var_file[2]}
		else
			echo "${t[$i]}" >> ${var_file[0]}
			echo "${Uvx[$i]}" >> ${var_file[1]}
			echo "${Uvix[$i]}" >> ${var_file[2]}
		fi
	done
	maxima -b scripts/Wxmax_scr/make_graphs.mac > /dev/null 2>&1
}
