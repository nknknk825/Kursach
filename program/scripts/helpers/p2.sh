#!/bin/sh

. ./functions.sh

# Функция pg2 — вызывает бинарный файл, считывает вывод и выводит табличные данные с погрешностью
pg2() {
    inp_data=("$1 $n $eps")                      # Формирование аргументов: номер варианта, количество точек, погрешность

    out_data=()                                  # Очистка массива выходных данных

    # Запуск бинарного приложения и построчное считывание вывода
    while read -r line; do
        out_data+=("$line")                      # Добавление каждой строки в массив
    done <<< "$(./bin/myapp ${inp_data[@]})"

    style "Результат программы: " $yellow > "data/tabls/table_p2.txt"        # Заголовок результата


	parametrs
	parametrs >> "data/tabls/table_p2.txt"
    # Чтение заголовка таблицы
    read -a header <<< "${out_data[0]}"
    printf "\n  ${yellow}%7s %12s %14s${nc}\n" " ${header[0]}" "${header[1]}" "${header[2]}"
    printf "%7s %12s %14s\n" "${header[0]}" "${header[1]}" "${header[2]}" >> "data/tabls/table_p2.txt"

    # Построчная обработка данных таблицы (начиная со второй строки)
    while read -a arr; do
        num=${arr[2]}                             # Извлечение значения погрешности
        num=$(awk "BEGIN { print ${arr[2]} * 100 }")
#        num=$(echo "${arr[2]} * 100" | bc -l)     # Преобразование в проценты

        # Печать строки в консоль
        printf "    ${yellow}%6d${nc} %10.3f %12f%%\n" \
            "${arr[0]}" "${arr[1]}" "${num}"

        # Запись строки в файл
        printf "%7d %10.3f %12f%%\n" \
            "${arr[0]}" "${arr[1]}" "${num}" >> "data/tabls/table_p2.txt"

        # Прекращение при достижении половины массива
        if [ "${arr[0]}" -gt "$((N/2))" ]; then
            style " Достигнут предел массива (${N} элементов). Остановка" $red
            break
        fi

    done < <(printf "%s\n" "${out_data[@]:1}")    # Передача строк начиная со второй (без заголовка)

    style "-> enter для окончания просмотра" $yellow n
    read

    clear                                         # Очистка экрана
}

