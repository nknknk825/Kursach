#!/bin/sh

pg2() {
	inp_data=("$1 11 12 12 10 35 22.5 5 25 20 150 $eps")
	out_data=()
    while read -r line;do
                out_data+=("$line")
    done <<< "$(./bin/myapp ${inp_data[@]})"

    style "Результат программы: " $yellow
#	echo "${out_data[@]}"
    read -a header <<< "${out_data[0]}"
    printf "\n  ${yellow}%-2s %7s %9s{nc}\n" " ${header[0]}" "${header[1]}" "${header[2]}"

    while read -a arr; do
        printf "    ${yellow}%6d${nc} %8.3f %8.3f%%\n" \
            "${arr[0]}" "${arr[1]}" "${arr[2]}"

    	if [ "${arr[0]}" -gt "$((N/2))" ];then
    		style "	Достигнут предел массива (${N} элементов). Остановка" $red
    		break
    	fi

    done < <(printf "%s\n" "${out_data[@]:1}")
    style "-> enter для окончания просмотра" $yellow n
    read
    clear

}
