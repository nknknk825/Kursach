#include <stdio.h>          // Для функций ввода-вывода (printf)
#include <math.h>           // Для математических операций

#include "globals.h"        // Заголовочный файл с глобальной структурой AppParams
#include "funct.h"          // Заголовочный файл, содержащий прототипы текущих функций

// Формирование массива времён t по шагу dt
void form_time(struct AppParams ap_pr, float* t) {
    float dt = (ap_pr.tk - ap_pr.tn) / (ap_pr.n - 1);  // Шаг между точками времени
    for (int i = 0; i < ap_pr.n; i++) {
        t[i] = ap_pr.tn + i * dt;                      // t[i] = начальное + шаг * номер
    }
}

// Формирование массива значений Uvx по заданному закону
void form_Uvx(struct AppParams ap_pr, float* t, float* Uvx) {
    for (int i = 0; i < ap_pr.n; i++) {
        if (t[i] < ap_pr.t1) {
            // До t1 — линейный рост
            Uvx[i] = ap_pr.a * (t[i] - ap_pr.tn);
        } else {
            // После t1 — линейное убывание
            Uvx[i] = ap_pr.a * (ap_pr.t1 - ap_pr.tn) - ap_pr.b * (t[i] - ap_pr.t1);
        }
    }
}

// Формирование массива значений Uvix на основе Uvx по кусочной линейной аппроксимации
void form_Uvix(struct AppParams ap_pr, float* Uvx, float* Uvix) {
    for (int i = 0; i < ap_pr.n; i++) {
        if (Uvx[i] <= ap_pr.Uvx1)
            Uvix[i] = ap_pr.U1;                        // Меньше порога — константа U1
        else if (Uvx[i] >= ap_pr.Uvx2)
            Uvix[i] = ap_pr.U2;                        // Больше порога — константа U2
        else
            Uvix[i] = 6.5 * Uvx[i] - 12.5;              // Промежуточное значение — линейная функция
    }
}

// Функция вычисляет продолжительность (в секундах), когда сигнал превышает порог
float parametr(int n, float dt, float *U) {
    float Umin = U[0], Umax = U[0];
    for (int i = 1; i < n; i++) {
        if (U[i] < Umin) Umin = U[i];
        if (U[i] > Umax) Umax = U[i];
    }

    float threshold = Umin + 0.5 * (Umax - Umin);       // Порог = середина диапазона
    float duration = 0;

    for (int i = 0; i < n; i++) {
        if (U[i] >= threshold) {
            duration += dt;                             // Считаем длительность превышения порога
        }
    }

    return duration;
}

// Вывод таблицы значений t, Uvx, Uvix в три строки
void form_tabl1(int n, float* t, float* Uvx, float* Uvix) {
    for (int i = 0; i < n * 3; i++) {
        if (i < n) {
            if (i < (n - 1)) printf("%.3g ", t[i]);
            else printf("%.3g\n", t[i]);
        } else if (i < n * 2) {
            if (i < (n * 2 - 1)) printf("%.3g ", Uvx[i - n]);
            else printf("%.3g\n", Uvx[i - n]);
        } else {
            if (i < (n * 3 - 1)) printf("%.3g ", Uvix[i - n * 2]);
            else printf("%.3g\n", Uvix[i - n * 2]);
        }
    }
}
