#!/bin/sh

# Функция out_file — записывает массивы t, Uvx и Uvix в отдельные текстовые файлы
# и запускает скрипт для построения графиков с помощью Maxima
out_file() {
    clear
    style "Происходит запись в файл!" $green
    var_file=(                                   # Массив с путями к выходным файлам
        "./data/massiv_t.txt"
        "./data/massiv_Uvx.txt"
        "./data/massiv_Uvix.txt"
    )

    # Цикл по индексам массива t
    for i in "${!t[@]}"; do
        if [ "$i" == "0" ]; then
            # Первая строка — перезапись файлов
            echo "${t[$i]}" > ${var_file[0]}
            echo "${Uvx[$i]}" > ${var_file[1]}
            echo "${Uvix[$i]}" > ${var_file[2]}
        else
            # Остальные строки — дозапись в файлы
            echo "${t[$i]}" >> ${var_file[0]}
            echo "${Uvx[$i]}" >> ${var_file[1]}
            echo "${Uvix[$i]}" >> ${var_file[2]}
        fi
        if [ "$n" -ge "1000" ];then
	        prgs_bar $((i+1)) $n "Прогресс записи в файл"
        fi
    done
	clear
	style "Данные успешно записанны в файл!" $green
	style "Происходит рисование графиков пожалуйста подождите!" $green
    # Запуск Maxima-скрипта для построения графиков
    maxima -b scripts/Wxmax_scr/make_graphs.mac > /dev/null 2>&1

    clear
    style "Графики успешно нарисованы!" $yellow
    style "Вывести открыть графики ? (y/n)" $blue n
    read -rsn1 nn
    if [ "$nn" == "y" ]; then
        style "\nЗакройте окно с графиками для продолжения!" $yellow
        eog data/graphs/graph_Uvx.png > /dev/null 2>&1    # Открытие изображения через eog
    fi
}

