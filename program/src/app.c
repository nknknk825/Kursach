#include <stdlib.h>         // Подключение стандартной библиотеки (atoi, atof)

#include "globals.h"        // Заголовочный файл с глобальными переменными или структурами
#include "funct.h"
#include "stdio.h"

// Главная управляющая функция приложения
void run_app(int count, char* arg[]) {
    // Инициализация структуры параметров приложения
    struct AppParams ap_pr = {
		.a = 20,
		.b = 0.5,
		.c = 17,
		.tn = 5,
		.t1 = 10,
		.t2 = 15,
		.t3 = 45,
		.t4 = 50,
		.tk = 60,
		.Uvx1 = 10,
		.Uvx2 = 30,

		.n = atoi(arg[2])
    };

    // Выбор действия по номеру варианта, переданного в аргументах
    switch (atoi(arg[1])) {
        case 1:
            // Вариант 1: выполнить прямой расчёт
            control_calc(ap_pr);
            break;

        case 2:
            // Вариант 2: установить погрешность и выполнить приближённый расчёт
            ap_pr.eps = atoi(arg[3])/100;   // Перевод из процентов в дробное значение
            approx_value(ap_pr);
            break;
		case 3:
				float* arr;
				int line = 0;
				int str_inx = 3;

				for (int i = str_inx; i < count;i++) {
					if (i == str_inx) arr = ap_pr.t;
					if (i == (ap_pr.n+str_inx)) { arr = ap_pr.Uvx; line = 1;}
					if (i == (ap_pr.n*2+str_inx)) { arr = ap_pr.Uvix; line = 2;}

					arr[(i-str_inx)-line*ap_pr.n] = atof(arg[i]);
				}
				file_out_data(ap_pr.n, ap_pr.t, ap_pr.Uvx, ap_pr.Uvix);
			break;

    }
}
