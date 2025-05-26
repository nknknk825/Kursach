#include <stdlib.h>         // Подключение стандартной библиотеки (atoi, atof)

#include "globals.h"        // Заголовочный файл с глобальными переменными или структурами
#include "funct.h"

// Главная управляющая функция приложения
void run_app(int count, char* arg[]) {
    // Инициализация структуры параметров приложения
    struct AppParams ap_pr = {
        .a = 20,            // значение a
	    .b = 0.5,			// значение b
	    .c = 17,			// значение c
        .tn = 5,            // Начальное время tn
        .t1 = 15,			// Момент времени t1
        .t2 = 45,			// Момент времени t2
        .tk = 50,           // Конечное время tk
        .n = atoi(arg[2]),   // Количество точек, переданное через аргументы
        .eps = atof(arg[3]) // Предел погрешности
    };

    // Выбор действия по номеру варианта, переданного в аргументах
    switch (atoi(arg[1])) {
        case 1:
            // Вариант 1: выполнить прямой расчёт
            control_calc(ap_pr);
            break;

        case 2:
            // Вариант 2: установить погрешность и выполнить приближённый расчёт
            ap_pr.eps /= 100;   // Перевод из процентов в дробное значение
            approx_value(ap_pr);
            break;

        case 3:
            float* arr;
            int line = 0;
            int str_inx = 3;

            for (int i = str_inx; i < count;i++) {
                if (i >= (ap_pr.n*2+str_inx)) {
					ap_pr.Uvix[(i-str_inx)-2*ap_pr.n] = atof(arg[i]);
				} else {
	                if (i == str_inx) arr = ap_pr.t;
	                else if (i == (ap_pr.n+str_inx)) { arr = ap_pr.Uvx; line = 1;}

	                arr[(i-str_inx)-line*ap_pr.n] = atof(arg[i]);
                }
            }
            file_out_data(ap_pr.n, ap_pr.t, ap_pr.Uvx, ap_pr.Uvix);
        break;
    }
}
