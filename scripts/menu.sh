#!/bin/bash
clear
. ./scripts/helpers/variables.sh --source-only
. ./scripts/helpers/functions.sh --source-only

pg1() {
    out_data=()
	inp_data=(1 11 12 12 10 35 22.5 5 25 20 150)

    while read -r line;do
        out_data+=("$line")
    done <<< "$(./bin/myapp ${inp_data[@]})"


	style "Результат программы: " $yellow

	read -a arry <<< "${out_data[@]:0:1}"
	printf "${yellow}%-6s %-6s %-6s %-6s${nc}\n" "${arry[0]}" "${arry[1]}" "${arry[2]}" "${arry[3]}"

	let "len=${#out_data[@]}-1"
    for arr in "${out_data[@]:0:$len}";do
		printf "	${yellow}%-6s${nc} %-6s" "${arr[0]}" "${arr[1]}"
		printf "	%-6s %-6s\n" "${arr[2]}" "${arr[3]}"
    done
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
				1)
                                        style "Диапазон длинны: [2;1000]" $yellow
                                        while true;do
                                                is_number "	Ведите длинну массива: "
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
				;;&
				[1-2])
					clear
					out_zast
					style "Данные из программы успешно считанны!" $green
					pg1
#					start_func $num
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
