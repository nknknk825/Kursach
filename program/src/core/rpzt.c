#include "stdio.h"      // Для printf
#include "globals.h"    // Структура AppParams и глобальные константы
#include "rpzt.h"       // Прототип approx_value
#include "funct.h"      // Прототипы функций расчёта
#include "math.h"       // Для fabs

// Функция приближённого расчёта значения параметра с заданной точностью
void approx_value(struct AppParams ap_pr) {
    float t[N], Uvx[N], Uvix[N];
    float p = 1;
    float par = 1e10;
    float par1 = 0;

    printf("n   parametr   pogrechnost\n");

    while (p > ap_pr.eps && ap_pr.n < N) {
        form_time(ap_pr, t);
        form_Uvx(ap_pr, t, Uvx);
        form_Uvix(ap_pr, Uvx, Uvix);

        par1 = parametr(ap_pr.n, 0, Uvix, t); // <--- передаем t и Uvix правильно
        p = fabs(par - par1) / fabs(par1);
        if (p > 1) p = 1;

        printf("%d   %.5f   %.5f\n", ap_pr.n, par1, p);

        par = par1;
        ap_pr.n = 2 * ap_pr.n;
    }

}
