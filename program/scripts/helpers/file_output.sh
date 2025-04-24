#!/bin/sh

# Функция out_file — записывает массивы t, Uvx и Uvix в отдельные текстовые файлы
# и запускает скрипт для построения графиков с помощью Maxima
out_file() {
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
    done

    # Запуск Maxima-скрипта для построения графиков
    maxima -b scripts/Wxmax_scr/make_graphs.mac > /dev/null 2>&1
}

