#include <stdio.h>          // Для функций ввода-вывода (printf)
#include <math.h>           // Для математических операций

#include "globals.h"        // Заголовочный файл с глобальной структурой AppParams
#include "funct.h"          // Заголовочный файл, содержащий прототипы текущих функций


// Формирование массива времён t по шагу dt
void form_time(float* t, int n) {
	float tn = TN;
	float tk = TK;
//	printf("|%f|", tk);

    float dt = (tk - tn) / (n - 1);  // Шаг между точками времени
    for (int i = 0; i < n; i++) {
        t[i] = tn + i * dt;                      // t[i] = начальное + шаг * номер
    }
}

// Формирование массива значений Uvx по заданному закону
void form_Uvx(float* t, float* Uvx, int n) {
    for (int i = 0; i < n; i++) {
		if (t[i] <= T1) Uvx[i] = 0;
		else if (t[i] <= T2) Uvx[i] = A_VX*(1-exp(-B_VX*(t[i]-T1)));
		else Uvx[i] = A_VX*(1-exp(-B_VX*(T2-T1))) * exp(C_VX*(t[i]-T2));
    }
}


// Формирование массива значений Uvix на основе Uvx по кусочной линейной аппроксимации
void form_Uvix(float* Uvx, float* Uvix, int n) {
    for (int i = 0; i < n; i++) {
		if (Uvx[i] <= UVX1) Uvix[i] = A1*Uvx[i]+B1;
		else if (Uvx[i] <= UVX2) Uvix[i] = A2*Uvx[i]+B2;
		else Uvix[i] = A3*Uvx[i]+B3;
    }
}

// Функция вычисляет продолжительность (в секундах), когда сигнал превышает порог
float parametr(int n, float sum, float *U, float *t) {
    // 1. Определяем точку перехода по Uvx (где происходит скачок)
    int transition_point = 0;
    for (int i = 1; i < n; i++) {
        if (fabs(U[i] - U[i-1]) > 5.0f) {  // Порог для обнаружения перехода
            transition_point = i;
            break;
        }
    }

    // 2. Вычисляем параметры перехода
    if (transition_point > 0) {
        // Основной параметр - время перехода
        float transition_time = t[transition_point];

        // Дополнительные характеристики:
        float Uvix_before = U[transition_point-1];
        float Uvix_after = U[transition_point];

        // Комбинированный параметр (можно адаптировать под ваши нужды)
        float param = transition_time * (Uvix_before - Uvix_after);

        return param;
    }

    // Если переход не обнаружен
    return 0.0f;

}

// Вывод таблицы значений t, Uvx, Uvix в три строки
void form_tabl1(int n, float* t, float* Uvx, float* Uvix) {
    for (int i = 0; i < n * 3; i++) {
        if (i < n) {
            if (i < (n - 1)) printf("%g ", t[i]);
            else printf("%g\n", t[i]);
        } else if (i < n * 2) {
            if (i < (n * 2 - 1)) printf("%g ", Uvx[i - n]);
            else printf("%g\n", Uvx[i - n]);
        } else {
            if (i < (n * 3 - 1)) printf("%g ", Uvix[i - n * 2]);
            else printf("%g\n", Uvix[i - n * 2]);
        }
    }
}

void control_calc(int n, int eps) {
    float t[N], Uvx[N], Uvix[N];       // Массивы для времён, промежуточного и результирующего напряжения

    form_time(t, n);              // Заполнение массива времени
    form_Uvx(t, Uvx, n);          // Расчёт промежуточного напряжения Uvx
    form_Uvix(Uvx, Uvix, n);      // Расчёт результирующего напряжения Uvix

	if (eps == 100) file_out_data(n, t, Uvx, Uvix);
	else form_tabl1(n, t, Uvx, Uvix); // Вывод таблицы значений
}

void file_out_data(int n, float* t, float* Uvx, float* Uvix) {
     FILE *f1,*f2,*f3;       //Объявление указателя на файловую переменную

     f1=fopen("./data/massiv_t.txt","w");
     f2=fopen("./data/massiv_Uvx.txt", "w");  //Открытие файлов на запись
     f3=fopen("./data/massiv_Uvix.txt", "w");
     for (int i = 0;i < n;i++)
     {
        fprintf(f1,"\n %g",t[i]);
        fprintf(f2,"\n %g", Uvx[i]);         //Запись данных в файл
        fprintf(f3,"\n%g",Uvix[i]);
      }
      fclose(f1);
      fclose(f2);                                       //Закрытие файлов
      fclose(f3);
}

// Функция приближённого расчёта значения параметра с заданной точностью
void approx_value(int n, int eps) {
    float t[N], Uvx[N], Uvix[N];
    float p = 1;
    float par = 1e10;
    float par1 = 0;

    printf("n   parametr   pogrechnost\n");

    while (p > eps && n < N) {
        form_time(t, n);
        form_Uvx(t, Uvx, n);
        form_Uvix(Uvx, Uvix, n);

        par1 = parametr(n, 0, Uvix, t);
        p = fabs(par - par1) / fabs(par1);
        if (p > 1) p = 1;

        printf("%d   %.5f   %.5f\n", n, par1, p);

        par = par1;
        n = 2 * n;
    }

}
