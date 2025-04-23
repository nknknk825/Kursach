#!/bin/sh

pg1() {
    out_data=()
    inp_data=("$fun $n")

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
        esac
        let "i+=1"
    done <<< "$(./bin/myapp ${inp_data[@]})"


    style "Результат программы: " $yellow

    read -a header <<< "${out_data[0]}"
    printf "\n	${yellow}%-4s %7s %9s %8s${nc}\n" " №" "t" "Uvx" "Uvix"

    printf " %-4s %7s %9s %8s\n" "№" "t" "Uvx" "Uvix" > "output/table_p1.txt"

    for i in "${!t[@]}"; do
        printf "	${yellow}%4d${nc} %8.1f %8.1f %8.1f\n" \
            "$((i+1))" "${t[$i]}" "${Uvx[$i]}" "${Uvix[$i]}"

                    printf "%4d %8.1f %8.1f %8.1f\n" \
            "$((i+1))" "${t[$i]}" "${Uvx[$i]}" "${Uvix[$i]}" >> "output/table_p1.txt"

    done
    style "-> enter для окончания просмотра" $yellow n
    read
    clear
}
