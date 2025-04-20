#include "globals.h"
#include "krnt.h"
#include "funct.h"

void control_calc(struct AppParams ap_pr) {
//	float* t_in, Uvx_in, Uvix_in;
	float t[N], Uvx[N], Uvix[N];

	form_time(ap_pr, t);
	form_Uvx(ap_pr, t, Uvx);
	form_Uvix(ap_pr, Uvx, Uvix);

	form_tabl1(ap_pr.n, t, Uvx, Uvix);
}

