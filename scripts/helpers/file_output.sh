#!/bin/sh


out_file() {
	var_file=(
		"./data/massiv_t.txt"
		"./data/massiv_Uvx.txt"
		"./data/massiv_Uvix.txt")

	var_sf=("t" "Uvx" "Uvix")
	for i in {0..2};do
	echo "${var_sf[i]}" > "${var_file[i]}"
	done

	for i in "${!t[@]}";do
		echo "${t[$i]}" >> ${var_file[0]}
		echo "${Uvx[$i]}" >> ${var_file[1]}
		echo "${Uvix[$i]}" >> ${var_file[2]}
	done
}
