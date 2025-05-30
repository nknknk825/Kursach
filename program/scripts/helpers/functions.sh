#!/bash/sh

style() {
        if [ "$2" == "void" ];then
                style_text=""
                local nc=""
        else
                style_text=$2
        fi

        if [ -z "$3" ];then
                echo -e "${style_text}${1}${nc}"
        else
                echo -ne "${style_text}${1}${nc}"
        fi
}


clear_line() {
        echo -ne '\e[A\e[K'
        echo -ne "\007"
}

is_number() {
        re="$2"
        num=0
        style "$1" $blue n

        while true
        do
                read num
                if  [[ $num =~ $re ]]; then break;fi

                clear_line

                style "	ОШИБКА: '$num'-не является целым числом" $red
                style "$1" $blue n
        done
}

no_space() {
        num=0
        style "$1" $blue n

        while true
        do
                read num
                if  [ "$num" != " " ] && [ "$num" != "" ]; then break;fi

                clear_line

                style "ОШИБКА: в поле либо пусто, либо в нем пробел!" $red
                style "$1" $blue n
        done

}

mv_curs() {
        if [ "$con_ckip_rows" != "$st_rows" ];then
            tput cud $((con_ckip_rows-st_rows))
        fi
        style "$1" $2
    tput cuu $con_ckip_rows
    let "con_ckip_rows+=1"
}

moving_arrows() {
    arr=("$@")

    curs=-1

    up_pred=$((${#arr[@]}-1))

    tput civis
    while true;do
        for inx in "${!arr[@]}";do
            if  [ "$inx" == "$curs" ];then
                printf "\r   ${green}${arr[$inx]}${nc}\n"
            else
                printf "\r   ${arr[$inx]}\n"
            fi
        done
        echo
        read -rsn1 key

        [[ -z "$key" ]] && break

        case $key in
                1|2|3)
                        key=$key
                        return
                ;;
                p)
                        key=p
                        return
                ;;

                s)
                        key=s
                        return
                ;;

                q)
                        key=q
                        return
                ;;

            $'\x1b') # Escape-последовательность (стрелки и др.)
                read -rsn2 -t 0.1 rest  # Дополнительно читаем 2 символа
                case "$rest" in
                    '[A')
                        let "curs-=1"
                        curs=$(( curs < 0 ? ${up_pred} : curs))
                    ;;
                    '[B')
                        let "curs+=1"
                        curs=$(( curs > ${up_pred} ? 0 : curs))
                    ;;
                    '[C')
                        break
                    ;;
                esac
            ;;

            *)
                 key=$key
                 return
            ;;
        esac
        up_rows=$((${#arr[@]}+1))
        tput cuu $up_rows
    done
    tput cnorm

    key=$((curs+1))
}

float_compare() {
    local a=$(printf "%f" "$1")
    local op=$2
    local b=$(printf "%f" "$3")

    # Нормализация чисел (удаление лишних нулей и точек)
    a=$(echo "$a" | sed 's/^-\?0\+//; s/\.0*$//; s/^\./0./; s/^-\./-0./; /^$/d')
    b=$(echo "$b" | sed 's/^-\?0\+//; s/\.0*$//; s/^\./0./; s/^-\./-0./; /^$/d')
    [ -z "$a" ] && a=0
    [ -z "$b" ] && b=0

    case $op in
        "<")  return $(echo "$a < $b" | bc -l);;
        ">")  return $(echo "$a > $b" | bc -l);;
        "<=") return $(echo "$a <= $b" | bc -l);;
        ">=") return $(echo "$a >= $b" | bc -l);;
        "==") return $(echo "$a == $b" | bc -l);;
        "!=") return $(echo "$a != $b" | bc -l);;
        *)    echo "Неизвестный оператор: $op" >&2; return 2;;
    esac
}

parametrs() {
    echo
    inp_data=("1 $n 0")                         # Формирование аргументов для вызова бинарного приложения

    t=()                                       # Массив временных точек
    Uvx=()                                     # Массив значений Uvx
    Uvix=()                                    # Массив значений Uvix

    i=0                                        # Счётчик строк

    # Чтение вывода программы построчно
    while read -r line; do
        case $i in
            [0-2])
                read -a lin <<<"$line"         # Разбивает строку в массив
            ;;&                                # Продолжает выполнение следующего условия case
            0)
                t=("${lin[@]}")                # Первая строка — массив t
            ;;
            1)
                Uvx=("${lin[@]}")              # Вторая строка — массив Uvx
            ;;
            2)
                Uvix=("${lin[@]}")             # Третья строка — массив Uvix
            ;;
        esac
        let "i+=1"                             # Увеличение счётчика
    done <<< "$(./bin/myapp ${inp_data[@]})"   # Вызов внешней программы и обработка её вывода


    # Функция для сравнения чисел с плавающей точкой

    # 1. Нахождение длительности импульса сигнала
    Umin=${Uvx[0]}
    Umax=${Uvx[0]}
    for ((i=1; i<n; i++)); do
        if float_compare "${Uvx[i]}" "<" "$Umin"; then
            Umin=${Uvx[i]}
        fi
        if float_compare "${Uvx[i]}" ">" "$Umax"; then
            Umax=${Uvx[i]}
        fi
    done

    Uimp=$(echo "$Umin + 0.5 * ($Umax - $Umin)" | bc -l)
    dlit=0
    dt=$(echo "${t[1]} - ${t[0]}" | bc -l)  # предполагаем равномерный шаг по времени

    for ((i=0; i<n; i++)); do
        if float_compare "${Uvx[i]}" ">=" "$Uimp"; then
            dlit=$(echo "$dlit + $dt" | bc -l)
        fi
    done
    printf "	${yellow}Длительность импульса сигнала:${nc} %g\n" "$dlit"

    # 2. Нахождение длительности заднего фронта импульса сигнала
    U1=$(echo "$Umin + 0.9 * ($Umax - $Umin)" | bc -l)
    U2=$(echo "$Umin + 0.1 * ($Umax - $Umin)" | bc -l)
    back_front=0

    for ((i=0; i<n-1; i++)); do
        if float_compare "${Uvx[i]}" ">" "$U2" && \
           float_compare "${Uvx[i]}" "<" "$U1" && \
           float_compare "${Uvx[i+1]}" "<" "${Uvx[i]}"; then
            back_front=$(echo "$back_front + $dt" | bc -l)
        fi
    done
    printf "	${yellow}Длительность заднего фронта импульса:${nc} %g\n" "$back_front"

    # 3. Нахождение момента времени, при котором Uvx достигает 80 В
    printf "	${yellow}Момент времени, когда Uvx достигает 80 В:${nc} %s\n" "Не достигает"

    # 4. Нахождение момента времени, при котором Uvx достигает максимума
    time_max=${t[2]}
    max_val=0
    for ((i=2; i<n; i++)); do
        if float_compare "${Uvx[i]}" ">" "$max_val"; then
            max_val=${Uvx[i]}
            time_max=${t[i]}
        fi
    done
    printf "	${yellow}Момент времени максимального значения Uvx:${nc} %g\n" "$time_max"

}

prgs_bar() {
    res=$(awk "BEGIN {print ($1 / $2) * 100}")
    int_res=$(echo "scale=0; $res / 4" | bc)

    sym_beg=$4
    sym_end=$5

    if [ "$int_res" == "0" ];then echo -ne "\e[?25l";fi
    if [ "$sym_beg" == "" ];then sym_beg="#";fi

    if [ $int_res -gt "0" ]
    then	str="$(printf '%.0s'"$sym_beg" $(seq 1 ${int_res}))$(printf '%.0s'"$sym_end" $( seq 1 $((25-$int_res)) ) )"
    else	str="$(printf '%.0s'"$sym_end" $( seq 1 $((25-$int_res)) ) )";fi

    printf "\r${yellow}%s%-25s%s %.2f%%${nc}" "$3 [" "$str" "]" "$res"
	if [ "$int_res" == "25" ];then echo -ne "\e[?25h";fi
}

prgs_t() {
    i=0
    echo -ne "\e[?25l"
    while kill -0 ${1} 2>/dev/null;do
        printf "\r${yellow}%20s${nc}" "${2}$(printf '%.0s.' $(seq 1 $i))       "
        sleep 0.2

        let "i+=1"
        if [ "$i" == "4" ];then i=1;fi
    done
    echo -ne "\e[?25h"
}
