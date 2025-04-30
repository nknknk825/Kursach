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

prgs_bar() {
	num_b1=$1
	num_b2=$2
	text=$3
	res=$(awk "BEGIN {print ($num_b1 / $num_b2) * 100}")
	printf "\r${yellow}${text}: %.2f%%${nc}" "$res"
}

prgs_grahs() {
    i=0
    pid=$1
    while kill -0 $pid 2>/dev/null;do
        printf "\r${yellow}%20s${nc}" "Генерация графиков$(printf '%.0s.' $(seq 1 $i))       "
        sleep 0.2

        let "i+=1"
        if [ -f "data/graphs/graph_Uvix.png" ];then break;fi
        if [ "$i" == "4" ];then i=1;fi
    done
}
