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
