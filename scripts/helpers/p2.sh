#!/bin/sh

pg2() {
	inp_data=("$1 $n $eps")

	out_data=()

    while read -r line;do
        out_data+=("$line")
    done <<< "$(./bin/myapp ${inp_data[@]})"

    style "Результат программы: " $yellow
#	echo "${out_data[@]}"
    read -a header <<< "${out_data[0]}"
    printf "\n  ${yellow}%7s %12s %14s${nc}\n" " ${header[0]}" "${header[1]}" "${header[2]}"
    printf "%7s %12s %14s\n" "${header[0]}" "${header[1]}" "${header[2]}" > "data/tabls/table_p2.txt"

    while read -a arr; do
    	num=${arr[2]}
    	num=$(echo "${arr[2]} * 100" | bc -l)
        printf "    ${yellow}%6d${nc} %10.3f %12f%%\n" \
            "${arr[0]}" "${arr[1]}" "${num}"

        printf "%7d %10.3f %12f%%\n" \
            "${arr[0]}" "${arr[1]}" "${num}" >> "data/tabls/table_p2.txt"

    	if [ "${arr[0]}" -gt "$((N/2))" ];then
    		style "	Достигнут предел массива (${N} элементов). Остановка" $red
    		break
    	fi

    done < <(printf "%s\n" "${out_data[@]:1}")
    style "-> enter для окончания просмотра" $yellow n
    read
    clear

}
