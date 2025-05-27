#include <stdlib.h>         // Подключение стандартной библиотеки (atoi, atof)

#include "globals.h"        // Заголовочный файл с глобальными переменными или структурами
#include "funct.h"

// Главная управляющая функция приложения
void run_app(int count, char* arg[]) {

    // Выбор действия по номеру варианта, переданного в аргументах
    switch (atoi(arg[1])) {
        case 1:
            // Вариант 1: выполнить прямой расчёт
            control_calc(atoi(arg[2]), atoi(arg[3]));
            break;

        case 2:
            // Вариант 2: установить погрешность и выполнить приближённый расчёт
            approx_value(atoi(arg[2]), atoi(arg[3])/100);
            break;
    }
}
