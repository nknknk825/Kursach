#!/bin/sh

pg1() {
    out_data=()
    inp_data=("$fun $n ${def_data[@]}")

    t=()
    Uvx=()
    Uvix=()

    i=0

    while read -r line;do
        case $i in
        	[0-2])
        		read -a lin <<<"$line"
        	;;&
            0)
                t=("${lin[@]}")
            ;;
            1)
                Uvx=("${lin[@]}")
            ;;
            2)
                Uvix=("${lin[@]}")
            ;;
            *)
                out_data+=("$line")
            ;;
        esac
        let "i+=1"
    done <<< "$(./bin/myapp ${inp_data[@]})"


    style "Результат программы: " $yellow

    read -a header <<< "${out_data[0]}"
    printf "\n	${yellow}%-2s %7s %9s %8s${nc}\n" " ${header[0]}" "${header[1]}" "${header[2]}" "${header[3]}"

    while read -a arr; do
        printf "	${yellow}%2d${nc} %8.1f %8.1f %8.1f\n" \
            "${arr[0]}" "${arr[1]}" "${arr[2]}" "${arr[3]}"

    done < <(printf "%s\n" "${out_data[@]:1}")
    style "-> enter для окончания просмотра" $yellow n
    read
    clear
}
