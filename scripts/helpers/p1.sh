#!/bin/sh

pg1() {
    out_data=()
    inp_data=("1 10 12 12 10 35 22.5 5 25 20 150")

    t=()
    Uvx=()
    Uvix=()

    i=0

    while read -r line;do
        case $i in
            0)
                t=("t: $line")
            ;;
            1)
                Uvx=("Uvx: $line")
            ;;
            2)
                Uvix=("Uvix: $line")
            ;;
            *)
                out_data+=("$line")
            ;;
        esac
        let "i+=1"
    done <<< "$(./bin/myapp ${inp_data[@]})"


    style "Результат программы: " $yellow

    echo "	${t[@]}"
    echo "	${Uvx[@]}"
    echo "	${Uvix[@]}"

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
