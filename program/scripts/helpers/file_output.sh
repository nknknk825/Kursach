#!/bin/sh

# Функция out_file — записывает массивы t, Uvx и Uvix в отдельные текстовые файлы
# и запускает скрипт для построения графиков с помощью Maxima
out_file() {
    clear
    echo "Происходит запись в файл!"
    var_file=(                                   # Массив с путями к выходным файлам
        "./data/massiv_t.txt"
        "./data/massiv_Uvx.txt"
        "./data/massiv_Uvix.txt"
    )

	# Заполнение файлов масивами t/Uvx/Uvix
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

	clear
	echo "Данные успешно записанны в файл!"
	echo "Происходит генерация графиков пожалуйста подождите!"

    # Запуск Maxima-скрипта для построения графиков
    maxima -b scripts/Wxmax_scr/make_graphs.mac > /dev/null 2>&1 &

    wait
    clear
    echo "Графики успешно нарисованы!"
    echo -ne "Вывести открыть графики ? (y/n)"
    read -rsn1 nn
    if [ "$nn" == "y" ]; then
        echo -e "\nЗакройте окно с графиками для продолжения!"
        eog data/graphs/graph_Uvx.png > /dev/null 2>&1    # Открытие изображения через eog
    fi
}

