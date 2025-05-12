#!/bash/sh

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

                echo "	ОШИБКА: '$num'-не является целым числом"
                echo -ne "$1"
        done
}
