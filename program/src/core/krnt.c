#include "globals.h"    // Заголовочный файл с определением структуры AppParams и констант
#include "krnt.h"       // Заголовок с прототипом control_calc
#include "funct.h"      // Прототипы функций для расчёта и формирования таблиц

// Основная управляющая функция для варианта 1 — расчёт и вывод таблицы
void control_calc(struct AppParams ap_pr) {
    float t[N], Uvx[N], Uvix[N];       // Массивы для времён, промежуточного и результирующего напряжения

    form_time(ap_pr, t);              // Заполнение массива времени
    form_Uvx(ap_pr, t, Uvx);          // Расчёт промежуточного напряжения Uvx
    form_Uvix(ap_pr, Uvx, Uvix);      // Расчёт результирующего напряжения Uvix

    form_tabl1(ap_pr.n, t, Uvx, Uvix); // Вывод таблицы значений
}
