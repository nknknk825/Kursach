
#include "stdio.h"
#include "globals.h"

#include "rpzt.h"

#include "funct.h"
#include "math.h"

void approx_value(struct AppParams ap_pr) {
    float t[N], Uvx[N], Uvix[N];
	float p = 1;
	float par = 1e10;
	float par1 = 0;
	
	printf("n parametr pogrechnost\n");
	while (p > ap_pr.eps) {

	    form_time(ap_pr, t);
	    form_Uvx(ap_pr, t, Uvx);
	    form_Uvix(ap_pr, Uvx, Uvix);

		par1 = parametr(ap_pr.n, t, Uvix);
		p = fabs(par-par1)/fabs(par1);

		if (p > 1) p = 1;
		printf("%d  %g  %.3g\n", ap_pr.n, par1, p*100);

		par = par1;
		ap_pr.n = 2*ap_pr.n;
		if (ap_pr.n > N) {
			//printf("Достигнут предел массива (%d элементов). Останов.\n", N);
		    break;
		}
	}
}
