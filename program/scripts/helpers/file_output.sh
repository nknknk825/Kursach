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

	{
	    for i in "${!t[@]}"; do
	        echo "${t[$i]}"
	    done
	} > "${var_file[0]}" &

	{
	    for i in "${!Uvx[@]}"; do
	        echo "${Uvx[$i]}"
	    done
	} > "${var_file[1]}" &

	{
	    for i in "${!Uvix[@]}"; do
	        echo "${Uvix[$i]}"
	    done
	} > "${var_file[2]}" &

    prgs_t $! "Запись в файл"
	clear
	style "Данные успешно записанны в файл!" $green

    # Запуск Maxima-скрипта для построения графиков
    maxima -b scripts/Wxmax_scr/make_graphs.mac > /dev/null 2>&1 &
	prgs_t $! "Генерация графиков"

    clear
    style "Графики успешно нарисованы!" $yellow
    style "Вывести открыть графики ? (y/n)" $blue n
    read -rsn1 nn
    if [ "$nn" == "y" ]; then
        style "\nЗакройте окно с графиками для продолжения!" $yellow
        eog data/graphs/graph_Uvx.png > /dev/null 2>&1    # Открытие изображения через eog
    fi
}

