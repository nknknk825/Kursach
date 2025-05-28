#!/bin/bash

. ./scripts/functions.sh --source-only

clear    # Очистка экрана

export LC_NUMERIC=C    # Установка десятичного разделителя как точка

N=10000    # Максимальное количество точек

variant_menu=(
        "1 - Контрольный расчет для n точек            "
        "2 - Расчёт параметра с заданной точностью     "
        "3 - Запись данных в файлы                     "
        "4 - Построить и вывести графики Uvx и Uvix    "
        "o - Открыть отчет в pdf                       "
        "q - Выход из программы                        "
)

file_name_zast="./config/zast.txt"

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
    printf "\n	%-7s %8s %10s %9s\n" "   №" "t" "Uvx" "Uvix"
    printf "%-7s %8s %10s %9s\n" "   №" "t" "Uvx" "Uvix" > "./data/tabls/table_krnt.txt"

    # Печать и запись каждой строки таблицы
    for i in "${!t[@]}"; do
        printf "        %5d %9.1f %9.1f %9.1f\n" \
            "$((i+1))" "${t[$i]}" "${Uvx[$i]}" "${Uvix[$i]}"

        printf "%5d %9.1f %9.1f %9.1f\n" \
            "$((i+1))" "${t[$i]}" "${Uvx[$i]}" "${Uvix[$i]}" >> "./data/tabls/table_krnt.txt"
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

    echo "Результат программы: "  > "./data/tabls/table_rpzt.txt"        # Заголовок результата

	parametrs # Вывод доп-параметров
	parametrs >> "./data/tabls/table_rpzt.txt" # Вывод доп-параметров

    # Чтение заголовка таблицы
    read -a header <<< "${out_data[0]}"
    printf "\n  %7s %12s %14s\n" " ${header[0]}" "${header[1]}" "${header[2]}"
    printf "\n  %7s %12s %14s\n" " ${header[0]}" "${header[1]}" "${header[2]}"  >> "./data/tabls/table_rpzt.txt"

    # Построчная обработка данных таблицы (начиная со второй строки)
    while read -a arr; do
        num=${arr[2]}                             # Извлечение значения погрешности
        num=$(awk "BEGIN { print ${arr[2]} * 100 }")  # Преобразование в проценты

        # Печать строки в консоль
        printf "    %6d %10.3f %12f%%\n" \
            "${arr[0]}" "${arr[1]}" "${num}"

        printf "    %6d %10.3f %12f%%\n" \
            "${arr[0]}" "${arr[1]}" "${num}"  >> "./data/tabls/table_rpzt.txt"
		if float_compare "${eps}" "<=" "${num}";then
    		printf "\nДостигнут допустимая погрешность при параметре: ${arr[1]}\n"
			printf "\nДостигнут допустимая погрешность при параметре: ${arr[1]}\n" >> "./data/tabls/table_rpzt.txt"
			break
		else if [ "${arr[0]}" -gt "$((N/2))" ]; then
		        echo " Достигнут предел массива (${N} элементов). Остановка"
        		echo " Достигнут предел массива (${N} элементов). Остановка" >> "./data/tabls/table_rpzt.txt"
		    fi
    	fi

    done < <(printf "%s\n" "${out_data[@]:1}")    # Передача строк начиная со второй (без заголовка)

        # Прекращение при достижении половины массива


    echo -ne "-> enter для окончания просмотра"
    read

    clear                                         # Очистка экрана
}


# Функция вывода заставки
out_zast(){
	clear
    while read -r line; do
        echo "$line"    # Цветной вывод строки
    done < $file_name_zast    # Чтение строк из файла
    printf "\n\n"
}

# Функция отображения основного меню

clear
inp_data=()    # Массив входных данных
out_data=()    # Массив выходных данных

out_zast # Отображение заставки out_menu # Запуск главного меню

out_menu() {
    for indx in "${!variant_menu[@]}"; do
            echo "${variant_menu[${indx}]}"
    done
    echo


        echo -n "Выберите действие 1-4 и o (или q для выхода)"
        read -rsn1 key    # Чтение одного символа
		printf "\n"
}

while true; do
	ij=8
    echo -e "Управление меню происходит двумя способами:"
    echo "   Первое-символами(1, 2, 3, 4, o, q)"
    echo "   Второе-стрелочками(вниз-верх, и enter чтоб выбрать вариант)"

    echo -e "\nМеню программы:"
    while true; do
		moving_arrows "${variant_menu[@]}"
        case $key in
            1|2)

            	info_n=(
            		"null"
            		"Количество точек расчёта"
            		"Начало осчёта параметра eps"
            	)
                clear
                echo "Ведите n(${info_n[$key]}):"
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

				if [ "$key" == "2" ];then
                    echo "Ведите погрешность eps(допустимая погрешность):"
                    echo "Диапазон eps: [0.0001; 10]%"
                    while true; do
                        is_number "	Введите eps: " '^[0-9]*\.?[0-9]+$'    # Проверка вещественного числа

                        # Проверка: num > 0.00009
                        valid_min=$(echo "$num > 0.00009" | bc -l)
                        # Проверка: num < 10
                        valid_max=$(echo "$num < 10" | bc -l)

                        if [[ "$valid_min" -eq 1 && "$valid_max" -eq 1 ]]; then
                            break
                        elif [[ "$valid_max" -ne 1 ]]; then
                            clear_line
                            echo "	Ошибка: число ($num) > 20"
                        else
                            clear_line
                            echo "	Ошибка: число ($num) < 0.0009"
                        fi
                    done
                    eps=$num    # Сохранение значения
                fi

                clear
                echo "Данне успешно переданны в программу!"
                echo "Данные из программы успешно считанны!"
                pg${key} $key    # Вызов функции pg1 или pg2 в зависимости от выбора
                out_zast
                break
            ;;

            3)
                cn_vr=2
                if [ "${#t[@]}" -gt "0" ];then
                    clear
                    echo "Происходит запись в файл!"

                    # Заполнение файлов масивами t/Uvx/Uvix
                    inp_dt=("3" "${#t[@]}" "${t[@]}" "${Uvx[@]}" "${Uvix[@]}")
                    ./bin/prg "${inp_dt[@]}"

                    clear
                    echo "Данные успешно записанны в файл!"
                    read -p "Нажмите enter, чтобы продолжить"
                    out_zast
                    break
                else
                    mv_curs "Erorr: массивы t/Uvx/Uvix пусты!"
                fi
            ;;

            4)
            	if [ -s "./data/massiv_t.txt" ];then
            		clear
	                echo "Происходит генерация графиков пожалуйста подождите!"

	                # Запуск Maxima-скрипта для построения графиков
	                maxima -b scripts/Wxmax_scr/make_graphs.mac > /dev/null 2>&1

	                clear
	                echo "Графики успешно нарисованы!"
					echo "Графики выведены на экран!"

	                echo -e "\nЗакройте окно с графиками для продолжения!"
	                eog data/graphs/graph_Uvx.png > /dev/null 2>&1    # Открытие изображения через eog
	                clear
                    out_zast
	                break
                else
                	mv_curs "Erorr: файлы t/Uvx/Uvix пусты!"
                fi

            ;;

            5)
            	clear
            	echo "Закройте файл чтоб вернуться в главное меню!"
            	open "../note.pdf"

				out_zast
            	clear
            	break
            ;;

            6)
                break 2    # Завершение работы
            ;;

            *)
                mv_curs "Erorr: Не верное значение ($key) не входит в промежуток [1;4] и не является(o, q)!"
            ;;

        esac
    done
done

clear
exit    # Завершение

