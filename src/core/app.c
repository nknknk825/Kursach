#include "stdlib.h"

#include "globals.h"

#include "rpzt.h"
#include "krnt.h"

#include "app.h"

void run_app(int count, char* arg[]) {
    struct AppParams ap_pr = {
        .n = 11,          // Количество точек
        .eps = 0.01,      // Погрешность (если используется)
        .a = 12,          // Коэффициент a для Uvx
        .b = 12,          // Коэффициент b для Uvx
        .tn = 10.0,       // Начальное время
        .tk = 35.0,       // Конечное время
        .t1 = 22.5,       // Время пика сигнала
        .Uvx1 = 5.0,      // Нижний порог для Uvx
        .Uvx2 = 25.0,     // Верхний порог для Uvx
        .U1 = 20.0,       // Значение Uvix при Uvx < Uvx1
        .U2 = 150.0       // Значение Uvix при Uvx > Uvx2
    };
	ap_pr = read_params(count, arg, ap_pr);

	switch (atoi(arg[1])) {
		case 1:
			control_calc(ap_pr);
		break;
		case 2:
			approx_value(ap_pr);
		break;
	}
}

struct AppParams read_params(int count, char* arg[], struct AppParams ap_pr) {

	ap_pr.n = atoi(arg[2]);

	ap_pr.a = atof(arg[3]);
	ap_pr.b = atof(arg[4]);

	ap_pr.tn = atof(arg[5]);
	ap_pr.tk = atof(arg[6]);
	ap_pr.t1 = atof(arg[7]);

	ap_pr.Uvx1 = atof(arg[8]);
	ap_pr.Uvx2 = atof(arg[9]);
	ap_pr.U1 = atof(arg[10]);
	ap_pr.U2 = atof(arg[11]);

	if (atoi(arg[1]) == 2) ap_pr.eps = atof(arg[12]);

	return ap_pr;
}
