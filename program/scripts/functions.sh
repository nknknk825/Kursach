#!/bin/sh

clear_line() {
        echo -ne '\e[A\e[K'
        echo -ne "\007"
}

is_number() {
        re="$2"
        num=0
        echo -ne "$1"

        while true
        do
                read num
                if  [[ $num =~ $re ]]; then break;fi

                clear_line

                echo "  ОШИБКА: '$num'-не является целым числом"
                echo -ne "$1"
        done
}

mv_curs() {
	if [ "$ij" != "8" ];then
	    tput cud $((ij-8))
	fi
	echo "$1"
    tput cuu $ij
    let "ij+=1"
}

moving_arrows() {
    arr=("$@")

    yellow="\033[0;33m"
    nc="\033[0m"
    curs=-1

    up_pred=$((${#arr[@]}-1))

    tput civis
    while true;do
        for inx in "${!arr[@]}";do
            if  [ "$inx" == "$curs" ];then
                printf "\r   ${yellow}${arr[$inx]}${nc}\n"
            else
                printf "\r   ${arr[$inx]}\n"
            fi
        done
        echo
        read -rsn1 key

        [[ -z "$key" ]] && break

        case $key in
        	1|2|3|4)
        		echo "$key"
        		key=$key
        		echo "$key"
        		return
        	;;
        	o)
        		key=5
        		return
        	;;

        	q)
        		key=6
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
    done <<< "$(./bin/prg ${inp_data[@]})"   # Вызов внешней программы и обработка её вывода


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
    printf "    Длительность импульса сигнала: %g\n" "$dlit"

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
    printf "    Длительность заднего фронта импульса: %g\n" "$back_front"

    # 3. Нахождение момента времени, при котором Uvx достигает 80 В
    printf "    Момент времени, когда Uvx достигает 80 В: %s\n" "Не достигает"

    # 4. Нахождение момента времени, при котором Uvx достигает максимума
    time_max=${t[2]}
    max_val=0
    for ((i=2; i<n; i++)); do
        if float_compare "${Uvx[i]}" ">" "$max_val"; then
            max_val=${Uvx[i]}
            time_max=${t[i]}
        fi
    done
    printf "    Момент времени максимального значения Uvx: %g\n" "$time_max"

}
