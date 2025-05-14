#!/bin/bash
clear    # Очистка экрана

export LC_NUMERIC=C    # Установка десятичного разделителя как точка

N=10000    # Максимальное количество точек

variant_menu=(
        "1 - Контрольный расчет для n точек            "
        "2 - Расчёт параметра с заданной точностью     "
        "3 - Запись данных в файлы                     "
        "p - Вывод пояснений к параметрам              "
        "q - Выход из программы                        "
)

file_name_zast="./config/zast.txt"

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

                echo "  ОШИБКА: '$num'-не является целым числом"
                echo -ne "$1"
        done
}

# Функция pg1 — вызывает бинарный файл, считывает и обрабатывает его вывод
pg1() {
    out_data=()                                # Очистка массива выходных данных
    inp_data=("$1 $n 0")                         # Формирование аргументов для вызова бинарного приложения

    t=()                                       # Массив временных точек
    Uvx=()                                     # Массив значений Uvx
    Uvix=()                                    # Массив значений Uvix

    i=0                                        # Счётчик строк
    n_n=$n

    # Чтение вывода программы построчно
    while read -r line; do
        case $i in
            [0-2])
                read -a lin <<<"$line"         # Разбивает строку в массив
            ;;&                                # Продолжает выполнение следующего условия case
            0)
                t=("${lin[@]}")                # Первая строка — массив t
            ;;
            1)
                Uvx=("${lin[@]}")              # Вторая строка — массив Uvx
            ;;
            2)
                Uvix=("${lin[@]}")             # Третья строка — массив Uvix
            ;;
        esac
        let "i+=1"                             # Увеличение счётчика
    done <<< "$(./bin/prg ${inp_data[@]})"   # Вызов внешней программы и обработка её вывода


    echo "Результат программы: "

    read -a header <<< "${out_data[0]}"   # Чтение первой строки как заголовок (не используется далее)

    # Печать заголовка таблицы в консоль
    printf "\n  %-7s %8s %10s %9s\n" "   №" "t" "Uvx" "Uvix"

    # Запись заголовка таблицы в файл
    printf "%-4s %7s %9s %8s\n" "№" "t" "Uvx" "Uvix" > "data/tabls/table_krnt.txt"

    # Печать и запись каждой строки таблицы
    for i in "${!t[@]}"; do
        printf "        %5d %9.1f %9.1f %9.1f\n" \
            "$((i+1))" "${t[$i]}" "${Uvx[$i]}" "${Uvix[$i]}"

        printf "%5d %9.1f %9.1f %9.1f\n" \
            "$((i+1))" "${t[$i]}" "${Uvx[$i]}" "${Uvix[$i]}" >> "data/tabls/table_krnt.txt"
    done

    echo -ne "\n-> enter для окончания просмотра"
    read
    clear    # Очистка экрана
}

# Функция pg2 — вызывает бинарный файл, считывает вывод и выводит табличные данные с погрешностью
pg2() {
    inp_data=("$1 $n $eps")                      # Формирование аргументов: номер варианта, количество точек, погрешность

    out_data=()                                  # Очистка массива выходных данных

    # Запуск бинарного приложения и построчное считывание вывода
    while read -r line; do
        out_data+=("$line")                      # Добавление каждой строки в массив
    done <<< "$(./bin/prg ${inp_data[@]})"

    echo "Результат программы: "        # Заголовок результата

    # Чтение заголовка таблицы
    read -a header <<< "${out_data[0]}"
    printf "\n  %7s %12s %14s\n" " ${header[0]}" "${header[1]}" "${header[2]}"
    printf "%7s %12s %14s\n" "${header[0]}" "${header[1]}" "${header[2]}" > "data/tabls/table_rpzt.txt"

    # Построчная обработка данных таблицы (начиная со второй строки)
    while read -a arr; do
        num=${arr[2]}                             # Извлечение значения погрешности
        num=$(awk "BEGIN { print ${arr[2]} * 100 }")  # Преобразование в проценты

        # Печать строки в консоль
        printf "    %6d %10.3f %12f%%\n" \
            "${arr[0]}" "${arr[1]}" "${num}"

        # Запись строки в файл
        printf "%7d %10.3f %12f%%\n" \
            "${arr[0]}" "${arr[1]}" "${num}" >> "data/tabls/table_rpzt.txt"

        # Прекращение при достижении половины массива
        if [ "${arr[0]}" -gt "$((N/2))" ]; then
            echo " Достигнут предел массива (${N} элементов). Остановка" >> "data/tabls/table_rpzt.txt"
            break
        fi

    done < <(printf "%s\n" "${out_data[@]:1}")    # Передача строк начиная со второй (без заголовка)

    echo -ne "-> enter для окончания просмотра"
    read

    clear                                         # Очистка экрана
}


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

        echo -e "Меню программы:"
        for indx in "${!variant_menu[@]}"; do
                echo "${variant_menu[${indx}]}"
        done
        echo
        while true; do


            echo -n "Выберите действие 1-3 и p или q для выхода "
            read -rsn1 key    # Чтение одного символа
			printf "\n"
        	cn_vr=2
            case $key in
            	1|2|p)
            		afplay -q 1 ./scripts/mp3_file/blaster.mp3
            	;;
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
                	cn_vr=2
                	if [ "${#t[@]}" -gt "0" ];then
                			afplay -q 1 ./scripts/mp3_file/blaster.mp3
                    	    clear
						    echo "Происходит запись в файл!"

						    # Заполнение файлов масивами t/Uvx/Uvix
						    ./bin/prg 1 ${#t[@]} 100

						    clear
						    echo "Данные успешно записанны в файл!"
						    echo "Происходит генерация графиков пожалуйста подождите!"

						    # Запуск Maxima-скрипта для построения графиков
						    maxima -b scripts/Wxmax_scr/make_graphs.mac > /dev/null 2>&1

						    clear
						    echo "Графики успешно нарисованы!"
						    echo -ne "Вывести графики ? (y/n)"
						    read -rsn1 nn
						    if [ "$nn" == "y" ]; then
						        echo -e "\nЗакройте окно с графиками для продолжения!"
						        open data/graphs/graph_Uvx.png > /dev/null 2>&1    # Открытие изображения через open
						        open data/graphs/graph_Uvix.png > /dev/null 2>&1    # Открытие изображения через open
						    fi
						    cn_vr=3
                    else
	                    clear_line
	                    say -v Zarvox "массивы t/Uvx/Uvix пусты"
	                    echo "Erorr: массивы t/Uvx/Uvix пусты!"
                    fi
                ;;&

                p)
				    out_file_name=(
				        "./config/explantion_krnt.txt"
				        "./config/explantion_rpzt.txt"
				    )
				    clear
				    # Вывод пояснений к водимым параметрам программы
				    for file_name in "${out_file_name[@]}";do
				        while IFS= read -r line;do
				            echo "$line"
				        done < "$file_name"
				        if [ "$file_name" != "${out_file_name[-1]}" ];then
				            echo -ne "\nНажмите enter чтоб перелестнуть страницу!"
				        else
				            echo -ne "\nНажмите enter чтоб закончить просмотр!"
				        fi
				        read
				        clear
				    done

	            ;;&

                [1-$cn_vr]|p)
                    clear
                    out_zast    # Повторный вывод заставки
                    break
                ;;

                q)
                    return    # Завершение работы
                ;;

                3)
                ;;

                *)
                    clear_line
                    say -v Zarvox "Не верное значение ($key) не входит в промежуток [1;$cn_vr] и p!"
                    echo "Erorr: Не верное значение ($key) не входит в промежуток [1;$cn_vr] и p!"
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
(while true; do afplay -q 1 ./scripts/mp3_file/start_wars.mp3; done) &
mp=$!

start    # Старт программы
kill $mp >/dev/null
clear
exit    # Завершение

