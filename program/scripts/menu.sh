#!/bin/bash
clear    # Очистка экрана

# Подключение вспомогательных скриптов с переменными и функциями
. ./scripts/helpers/variables.sh --source-only
. ./scripts/helpers/functions.sh --source-only

# Подключение вспомогательных частей программы
. ./scripts/helpers/p1.sh --source-only
. ./scripts/helpers/p2.sh --source-only
. ./scripts/helpers/file_output.sh --source-only
. ./scripts/helpers/output_data.sh --source-only

export LC_NUMERIC=C    # Установка десятичного разделителя как точка

N=10000    # Максимальное количество точек


# Функция вывода заставки
out_zast(){
    while read -r line; do
        echo "$line"    # Цветной вывод строки
    done < $file_name_zast    # Чтение строк из файла
    printf "\n\n"
}

# Функция отображения основного меню
out_menu() {
    while true; do

        printf "%.0s*" $(seq 1 54)
        echo -e "\n*  Меню программы:                                   *"
        for indx in "${!variant_menu[@]}"; do
            if [ "$indx" != "2" ]; then
                echo "*    ${variant_menu[${indx}]}  *"
            elif [[ "$indx" == "2" && "${#t[@]}" -gt "0" ]]; then
                echo "*    ${variant_menu[${indx}]}  *"
            fi
        done
        printf "%.0s*" $(seq 1 54)
        echo -e "\n"
        while true; do

            # Определение доступных пунктов меню
            if [ "${#t[@]}" -gt "0" ]; then con_vr=3
            else con_vr=2; fi

            echo -n "Выберите действие 1-${con_vr} и p или q для выхода "
            read -rsn1 key    # Чтение одного символа
			printf "\n"
            case $key in
                1|2)
                    clear
                    echo "Ведите n точек:"
                    echo "Диапазон n: [2;${N}]"
                    while true; do
                        is_number "	Ведите n: " '^[0-9]+$'    # Проверка ввода целого числа
                        if [ "$num" -gt "1" ]; then
                            if [ "$num" -le "$N" ]; then break
                            else
                                clear_line
                                echo "	Error: Число ($num) > $N"
                            fi
                        else
                            clear_line
                            echo "	Error: Число ($num) < 2"
                        fi
                    done
                    n=$num    # Сохранение введённого значения
                ;;&

                2)
                    echo "Ведите погрешность eps:"
                    echo "Диапазон eps: [0.001; 99.99]%"
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
                            echo "	Ошибка: число ($num) > 99.99"
                        else
                            clear_line
                            echo "	Ошибка: число ($num) < 0.0009"
                        fi
                    done
                    eps=$num    # Сохранение значения
                ;;&

                [1-2])
                    clear
                    echo "Данне успешно переданны в программу!"
                    echo "Данные из программы успешно считанны!"
                    pg${key} $key    # Вызов функции pg1 или pg2 в зависимости от выбора
                ;;&

                3)
                	if [ "$con_vr" == "3" ];then
                    	out_file    # Запись результатов в файл
                    else
	                    clear_line
	                    echo "Erorr: Не верное значение ($key) не входит в промежуток [1;$con_vr]!"
	                    break
                    fi
                ;;&

                p)
	                out_info_pr

	            ;;&

                [1-$con_vr]|p)
                    clear
                    out_zast    # Повторный вывод заставки
                    break
                ;;

                q)
                    return    # Завершение работы
                ;;

                *)
                    clear_line
                    echo "Erorr: Не верное значение ($key) не входит в промежуток [1;$con_vr] и p!"
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
clear
exit    # Завершение

