#!/bin/bash
clear
. ./scripts/helpers/variables.sh --source-only
. ./scripts/helpers/functions.sh --source-only


start_func(){
	style "Данные из программы успешно считанны!" $green
	out_data=(1)
}

out_zast(){
	while read -r line;do
		style "$line" $yellow
	done < $file_name_zast
	printf "\n\n"
}

out_menu() {
	while true;do

		style "Меню программы:" $green
		for indx in "${!variant_menu[@]}";do
			if [ "$indx" != "2" ];then
				style "${variant_menu[${indx}]}" $yellow
			elif [[ "$indx" == "2" && "${#out_data[@]}" -gt "0" ]];then
				style "${variant_menu[${indx}]}" $i_yellow
			fi
		done
		echo
		while true;do
			if [ "${#out_data[@]}" -gt "0" ];then num=3
			else num=2; fi
			style "Выберите действие 0-${num}: " $blue n
			read num
			case $num in
				[1-2])
					clear
					out_zast
					start_func $num
					break
				;;

				3)
					break 2
				;;

				0)
					style "\nУспешно вышли из программы" $green
					exit
				;;

				*)
					clear_line
					style "Erorr: Не верное значение ($num) не входит в промежуток [0;3]!" $red
				;;

			esac
		done
	done
}

start() {
	inp_data=()
	out_data=()

	out_zast
	out_menu
	clear
}

while true;do
	start
	style "Желаете перезапустить программу? (y/n) " $blue n
	read yn
	if [ "${yn}" == "n" ];then break;fi
done

style "\nПрограмма успешно завершена" $green
exit
