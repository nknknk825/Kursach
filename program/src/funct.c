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
		if (t[i] <= ap_pr.t1) Uvx[i] = ap_pr.a*(t[i] - ap_pr.tn);
		else if (t[i] <= ap_pr.t2) Uvx[i] = ap_pr.a*(ap_pr.t1 - ap_pr.tn) - ap_pr.b*(t[i] - ap_pr.t1);
		else Uvx[i] = ap_pr.a*(ap_pr.t1 - ap_pr.tn) - ap_pr.b*(ap_pr.t2 - ap_pr.t1) - ap_pr.c*(t[i] - ap_pr.t2);
    }
}

// Формирование массива значений Uvix на основе Uvx по кусочной линейной аппроксимации
void form_Uvix(struct AppParams ap_pr, float* Uvx, long double* Uvix) {
    for (int i = 0; i < ap_pr.n; i++) {
		Uvix[i] = 5*exp(0.5*Uvx[i]);
    }
}

// Функция вычисляет продолжительность (в секундах), когда сигнал превышает порог
float parametr(int n, float sum, long double *Uvix, float *t) {
    double sum_lnU = 0.0, sum_t = 0.0, sum_t2 = 0.0, sum_tlnU = 0.0;

    // 1. Линеаризация: ln(Uvix) = ln(a) + b*t
    for (int i = 0; i < n; i++) {
        if (Uvix[i] <= 0) continue;  // Пропуск невалидных точек
        double lnU = log(Uvix[i]);
        sum_lnU += lnU;
        sum_t += t[i];
        sum_t2 += t[i] * t[i];
        sum_tlnU += t[i] * lnU;
    }

    // 2. Решение системы уравнений для ln(a) и b
    double b = (n * sum_tlnU - sum_t * sum_lnU) / (n * sum_t2 - sum_t * sum_t);
    double ln_a = (sum_lnU - b * sum_t) / n;

    return exp(ln_a);  // Возвращаем параметр 'a' из модели Uvix = a * exp(b*t)
}

// Вывод таблицы значений t, Uvx, Uvix в три строки
void form_tabl1(int n, float* t, float* Uvx, long double* Uvix) {
    for (int i = 0; i < n * 3; i++) {
        if (i < n) {
            if (i < (n - 1)) printf("%.3g ", t[i]);
            else printf("%.3g\n", t[i]);
        } else if (i < n * 2) {
            if (i < (n * 2 - 1)) printf("%.3g ", Uvx[i - n]);
            else printf("%.3g\n", Uvx[i - n]);
        } else {
            if (i < (n * 3 - 1)) printf("%.3Lg ", Uvix[i - n * 2]);
            else printf("%.3Lg\n", Uvix[i - n * 2]);
        }
    }
}

void control_calc(struct AppParams ap_pr) {
    form_time(ap_pr, ap_pr.t);              // Заполнение массива времени
    form_Uvx(ap_pr, ap_pr.t, ap_pr.Uvx);          // Расчёт промежуточного напряжения Uvx
    form_Uvix(ap_pr, ap_pr.Uvx, ap_pr.Uvix);      // Расчёт результирующего напряжения Uvix

	form_tabl1(ap_pr.n, ap_pr.t, ap_pr.Uvx, ap_pr.Uvix); // Вывод таблицы значений
}

void file_out_data(int n, float* t, float* Uvx, long double* Uvix) {
     FILE *f1,*f2,*f3;       //Объявление указателя на файловую переменную

     f1=fopen("./data/massiv_t.txt","w");
     f2=fopen("./data/massiv_Uvx.txt", "w");  //Открытие файлов на запись
     f3=fopen("./data/massiv_Uvix.txt", "w");
     for (int i = 0;i < n;i++)
     {
        fprintf(f1,"\n%6.4f",t[i]);
        fprintf(f2,"\n%6.4f", Uvx[i]);         //Запись данных в файл
        fprintf(f3,"\n%6.4Lf",Uvix[i]);
      }
      fclose(f1);
      fclose(f2);                                       //Закрытие файлов
      fclose(f3);
}

// Функция приближённого расчёта значения параметра с заданной точностью
void approx_value(struct AppParams ap_pr) {
    long double p = 1;
    long double par = 1e10;
    long double par1 = 0;

    printf("n   parametr   pogrechnost\n");

    while (p > ap_pr.eps && ap_pr.n < N) {
        form_time(ap_pr, ap_pr.t);
        form_Uvx(ap_pr, ap_pr.t, ap_pr.Uvx);
        form_Uvix(ap_pr, ap_pr.Uvx, ap_pr.Uvix);

        par1 = parametr(ap_pr.n, 0, ap_pr.Uvix, ap_pr.t);
        p = fabs(par - par1) / fabs(par1);
        if (p > 1) p = 1;

        printf("%d   %Lg   %Lg\n", ap_pr.n, par1, p);

        par = par1;
        ap_pr.n = 2 * ap_pr.n;
    }

}
