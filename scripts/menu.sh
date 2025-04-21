#!/bin/bash
clear

. ./scripts/helpers/variables.sh --source-only
. ./scripts/helpers/functions.sh --source-only

. ./scripts/helpers/p1.sh --source-only
. ./scripts/helpers/p2.sh --source-onlyK
. ./scripts/helpers/file_output.sh --source-onlyK


export LC_NUMERIC=C

N=1000

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

			if [ "${#out_data[@]}" -gt "0" ];then num=3
			else num=2; fi

			style "Выберите действие 0-${num}: " $blue n
			read fun

			case $fun in
				1|2)
					clear
				;;&

				1)
					style "Ведите n точек:" $yellow
                    style "Диапазон длинны: [2;1000]" $yellow
                    while true;do
                            is_number "	Ведите длинну массива: " '^[0-9]+$'
                            if [ "$num" -gt "1" ]; then
                                    if [ "$num" -lt "1001" ]; then break
                                    else
                                            clear_line
                                            style "	Error: Число ($num) > 1000" $red
                                    fi
                            else
                                    clear_line
                                    style "	Error: Число ($num) <= 1" $red
                            fi
                    done
                    n=$num
				;;&

				2)
					style "Ведите погрешность eps:" $yellow
					style "Диапазон длины: (0.00001; 0.5)" $yellow
					n=11
					while true; do
					    is_number "Введите длину массива: " '^[0-9]*\.?[0-9]+$'

					    # Проверка: num > 0.00001
					    valid_min=$(echo "$num > 0.00001" | bc -l)
					    # Проверка: num < 0.5
					    valid_max=$(echo "$num < 0.5" | bc -l)

					    if [[ "$valid_min" -eq 1 && "$valid_max" -eq 1 ]]; then
					        break
					    elif [[ "$valid_max" -ne 1 ]]; then
					        clear_line
					        style "Ошибка: число ($num) > 0.5" $red
					    else
					        clear_line
					        style "Ошибка: число ($num) <= 0.00001" $red
					    fi
					done
                    eps=$num
				;;&

				[1-2])
					clear
					out_zast

					style "Данные из программы успешно считанны!" $green
					pg${fun} $fun
				break;;

				3)
					out_file
					clear
					style "Данные успешно записаны в файл!" $yellow
					style "Вывести данные на экран?(y/n)" $blue n
					read nn
					if [ "$nn" == "y" ];then
						cat data/*
					    style "-> enter для окончания просмотра" $yellow n
					    read
				 	fi
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
