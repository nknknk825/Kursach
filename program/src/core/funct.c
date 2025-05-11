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
		Uvx[i] = ap_pr.a0 + ap_pr.a1*t[i] + ap_pr.a2*pow(t[i],2);
    }
}

// Формирование массива значений Uvix на основе Uvx по кусочной линейной аппроксимации
void form_Uvix(struct AppParams ap_pr, float* Uvx, float* Uvix) {
    for (int i = 0; i < ap_pr.n; i++) {
		if (Uvx[i] <= ap_pr.Uvx1) Uvix[i] = 5;
		else Uvix[i] = 0.05*pow(Uvx[i], 2);
    }
}

// Функция вычисляет продолжительность (в секундах), когда сигнал превышает порог
float parametr(int n, float sum, float *U, float *t) {
    for (int i = 0; i < n; i++) {
        sum += U[i];
	}
    return sum / n;
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
