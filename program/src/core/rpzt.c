#include "stdio.h"      // Для printf
#include "globals.h"    // Структура AppParams и глобальные константы
#include "rpzt.h"       // Прототип approx_value
#include "funct.h"      // Прототипы функций расчёта
#include "math.h"       // Для fabs

// Функция приближённого расчёта значения параметра с заданной точностью
void approx_value(struct AppParams ap_pr) {
    float t[N], Uvx[N], Uvix[N];      // Массивы времени и напряжений
    float p = 1;                      // Начальное значение погрешности
    float par = 1e10;                 // Предыдущее значение параметра (большое значение для старта)
    float par1 = 0;                   // Текущее значение параметра

    float dt = (ap_pr.tk - ap_pr.tn) / (ap_pr.n - 1); // Шаг по времени

    printf("n parametr pogrechnost\n"); // Заголовок таблицы

    // Цикл итеративного уточнения параметра до достижения заданной погрешности
    while (p > ap_pr.eps && N > ap_pr.n) {

        form_time(ap_pr, t);          // Формирование массива времени
        form_Uvx(ap_pr, t, Uvx);      // Расчёт промежуточного напряжения
        form_Uvix(ap_pr, Uvx, Uvix);  // Расчёт результирующего напряжения

        par1 = parametr(ap_pr.n, dt, Uvix); // Вычисление параметра
        p = fabs(par - par1) / fabs(par1);  // Относительная погрешность

        if (p > 1) p = 1;             // Защита от взрыва значения p
        printf("%d  %g  %g\n", ap_pr.n, par1, p); // Вывод строки результата итерации

        par = par1;                   // Обновление предыдущего значения параметра
        ap_pr.n = 2 * ap_pr.n;       // Увеличение количества точек в 2 раза
        dt = (ap_pr.tk - ap_pr.tn) / (ap_pr.n - 1); // Пересчёт шага
    }
}
