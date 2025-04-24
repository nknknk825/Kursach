#!/bin/bash
clear    # Очистка экрана

# Подключение вспомогательных скриптов с переменными и функциями
. ./scripts/helpers/variables.sh --source-only
. ./scripts/helpers/functions.sh --source-only

# Подключение вспомогательных частей программы
. ./scripts/helpers/p1.sh --source-only
. ./scripts/helpers/p2.sh --source-onlyK    # Возможно, опечатка: должно быть --source-only
. ./scripts/helpers/file_output.sh --source-onlyK    # Аналогично, стоит проверить суффикс

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
            if [ "$indx" != "2" ]; then
                style "${variant_menu[${indx}]}" $yellow
            elif [[ "$indx" == "2" && "${#t[@]}" -gt "0" ]]; then
                style "${variant_menu[${indx}]}" $i_yellow
            fi
        done
        echo
        while true; do

            # Определение доступных пунктов меню
            if [ "${#t[@]}" -gt "0" ]; then num=3
            else num=2; fi

            style "Выберите действие 1-${num} или q для выхода " $blue n
            read -rsn1 key    # Чтение одного символа

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
                            style "	Error: Число ($num) <= 1" $red
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
                    out_file    # Запись результатов в файл
                    clear
                    style "Данные успешно записаны в файл!" $yellow
                    style "Графики успешно нарисованы!" $yellow
                    style "Вывести открыть графики ? (y/n)" $blue n
                    read -rsn1 nn
                    if [ "$nn" == "y" ]; then
                        style "\nЗакройте окно с графиками для продолжения!" $yellow
                        eog data/graphs/graph_Uvx.png > /dev/null 2>&1    # Открытие изображения через eog
                    fi
                ;;&

                [1-3])
                    clear
                    out_zast    # Повторный вывод заставки
                    break
                ;;

                q)
                    style "\nУспешно вышли из программы" $green
                    exit    # Завершение работы
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
    inp_data=()    # Массив входных данных
    out_data=()    # Массив выходных данных

    out_zast    # Отображение заставки
    out_menu    # Запуск главного меню
    clear
}

start    # Старт программы

# Возможность перезапуска (закомментирована)
# while true; do
#     start
#     style "Желаете перезапустить программу? (y/n) " $blue n
#     read yn
#     if [ "${yn}" == "n" ]; then break; fi
#     clear
# done

style "\nПрограмма успешно завершена" $green
exit    # Завершение

