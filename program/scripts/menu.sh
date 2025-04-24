#!/bin/bash
clear

. ./scripts/helpers/variables.sh --source-only
. ./scripts/helpers/functions.sh --source-only

. ./scripts/helpers/p1.sh --source-only
. ./scripts/helpers/p2.sh --source-onlyK
. ./scripts/helpers/file_output.sh --source-onlyK


export LC_NUMERIC=C

N=10000

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
			elif [[ "$indx" == "2" && "${#t[@]}" -gt "0" ]];then
				style "${variant_menu[${indx}]}" $i_yellow
			fi
		done
		echo
		while true;do

			if [ "${#t[@]}" -gt "0" ];then num=3
			else num=2; fi

			style "Выберите действие 1-${num} или q для выхода: " $blue n
			read fun

			case $fun in
				1|2)
					clear
					style "Ведите n точек:" $yellow
                    style "Диапазон n: [2;${N}]" $yellow
                    while true;do
                            is_number "	Ведите n: " '^[0-9]+$'
                            if [ "$num" -gt "1" ]; then
                                    if [ "$num" -lt "10001" ]; then break
                                    else
                                            clear_line
                                            style "	Error: Число ($num) > 10000" $red
                                    fi
                            else
                                    clear_line
                                    style "	Error: Число ($num) <= 1" $red
                            fi
                    done
                    n=$num
				;;&

				2)
					t=()
					style "Ведите погрешность eps:" $yellow
					style "Диапазон eps: [0.001; 99.99]%" $yellow
					while true; do
					    is_number "	Введите eps: " '^[0-9]*\.?[0-9]+$'

					    # Проверка: num > 0.00001
					    valid_min=$(echo "$num > 0.0009" | bc -l)
					    # Проверка: num < 0.5
					    valid_max=$(echo "$num < 99.99" | bc -l)

					    if [[ "$valid_min" -eq 1 && "$valid_max" -eq 1 ]]; then
					        break
					    elif [[ "$valid_max" -ne 1 ]]; then
					        clear_line
					        style "	Ошибка: число ($num) > 99.99" $red
					    else
					        clear_line
					        style "	Ошибка: число ($num) < 0.0009" $red
					    fi
					done
                    eps=$num
				;;&

				[1-2])
					clear
					style "Данне успешно переданны в программу!" $green
					style "Данные из программы успешно считанны!" $green
					pg${fun} $fun
				;;&

				3)
					out_file
					clear
					style "Данные успешно записаны в файл!" $yellow
					style "Графики успешно нарисованы!" $yellow
					style "Вывести открыть графики (y/n)? " $blue n
					read nn
					if [ "$nn" == "y" ];then
					    style "-> enter для окончания просмотра" $yellow n
						eog data/graphs/graph_Uvx.png > /dev/null 2>&1
					    read
				 	fi
				;;&

				[1-3])
					clear
					out_zast
				break;;

				q)
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
start
#while true;do
#	start
#	style "Желаете перезапустить программу? (y/n) " $blue n
#	read yn
#	if [ "${yn}" == "n" ];then break;fi
#	clear
#done

style "\nПрограмма успешно завершена" $green
exit
