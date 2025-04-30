#!/bin/bash
clear    # Очистка экрана

# Подключение вспомогательных скриптов с переменными и функциями
. ./scripts/helpers/variables.sh --source-only
. ./scripts/helpers/functions.sh --source-only

# Подключение вспомогательных частей программы
. ./scripts/helpers/p1.sh --source-only
. ./scripts/helpers/p2.sh --source-only
. ./scripts/helpers/file_output.sh --source-only

export LC_NUMERIC=C    # Установка десятичного разделителя как точка

N=10000    # Максимальное количество точек

# Функция вывода заставки
out_zast(){
    while read -r line; do
        style "$line" $yellow    # Цветной вывод строки
    done < $file_name_zast    # Чтение строк из файла
    printf "\n\n"
}

# Функция отображения основного меню
out_menu() {
    while true; do

        style "Меню программы:" $green
        for indx in "${!variant_menu[@]}"; do
            if [ "$indx" != "3" ]; then
                style "${variant_menu[${indx}]}" $yellow
            elif [[ "$indx" == "3" && "${#t[@]}" -gt "0" ]]; then
                style "${variant_menu[${indx}]}" $i_yellow
            fi
        done
        echo
        while true; do

            # Определение доступных пунктов меню
            if [ "${#t[@]}" -gt "0" ]; then num=4
            else num=3; fi

            style "Выберите действие 1-${num} или q для выхода " $blue n
            read -rsn1 key    # Чтение одного символа
			echo
            case $key in
                1|2)
                    clear
                    style "Ведите n точек:" $yellow
                    style "Диапазон n: [2;${N}]" $yellow
                    while true; do
                        is_number "	Ведите n: " '^[0-9]+$'    # Проверка ввода целого числа
                        if [ "$num" -gt "1" ]; then
                            if [ "$num" -lt "10001" ]; then break
                            else
                                clear_line
                                style "	Error: Число ($num) > 10000" $red
                            fi
                        else
                            clear_line
                            style "	Error: Число ($num) < 2" $red
                        fi
                    done
                    n=$num    # Сохранение введённого значения
                ;;&

                2)
                    style "Ведите погрешность eps:" $yellow
                    style "Диапазон eps: [0.001; 99.99]%" $yellow
                    while true; do
                        is_number "	Введите eps: " '^[0-9]*\.?[0-9]+$'    # Проверка вещественного числа

                        # Проверка: num > 0.0009
                        valid_min=$(echo "$num > 0.0009" | bc -l)
                        # Проверка: num < 99.99
                        valid_max=$(echo "$num < 99.99" | bc -l)

                        if [[ "$valid_min" -eq 1 && "$valid_max" -eq 1 ]]; then
                            break
                        elif [[ "$valid_max" -ne 1 ]]; then
                            clear_line
                            style "	Ошибка: число ($num) > 99.99" $red
                        else
                            clear_line
                            style "	Ошибка: число ($num) < 0.0009" $red
                        fi
                    done
                    eps=$num    # Сохранение значения
                ;;&

                [1-2])
                    clear
                    style "Данне успешно переданны в программу!" $green
                    style "Данные из программы успешно считанны!" $green
                    pg${key} $key    # Вызов функции pg1 или pg2 в зависимости от выбора
                ;;&

                3)
	                xterm \
					 -geometry 80x31-20+5 \
					 -bg black \
					 -bd red \
					 -fg green \
					 -fa 'Ubuntu Mono' \
					 -fs 15 \
					 -e 'tput civis; ./scripts/xterm_scripts/output_data.sh; tput cnorm'

	            ;;&

                4)
                	if [ "$num" == "4" ];then
                    	out_file    # Запись результатов в файл
                    else
	                    clear_line
	                    style "\nErorr: Не верное значение ($key) не входит в промежуток [1;$num]!" $red
                    fi
                ;;&

                [1-4])
                    clear
                    out_zast    # Повторный вывод заставки
                    break
                ;;

                q)
                    return    # Завершение работы
                ;;

                *)
                    clear_line
                    style "\nErorr: Не верное значение ($key) не входит в промежуток [1;$num]!" $red
                ;;

            esac
        done
    done
}

# Функция запуска программы
start() {
    clear
    inp_data=()    # Массив входных данных
    out_data=()    # Массив выходных данных

    out_zast    # Отображение заставки
    out_menu    # Запуск главного меню
}

start    # Старт программы

style "\nПрограмма успешно завершена" $green
i=3
while [ "$i" -gt "0" ];do
	style "Консоль очистится через: $i" $yellow
	let "i-=1"
	sleep 0.3
done
clear
exit    # Завершение

