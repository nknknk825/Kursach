#include <stdlib.h>

#include "globals.h"

#include "rpzt.h"
#include "krnt.h"

void run_app(int count, char* arg[]) {
    struct AppParams ap_pr = {
    	.a = 12,
    	.b = 12,
    	.tn = 10,
    	.tk = 35,
    	.t1 = 22.5,
    	.Uvx1 = 5,
    	.Uvx2 = 25,
    	.U1 = 20,
    	.U2 = 150,
		.n = atoi(arg[2])
    };

	switch (atoi(arg[1])) {
		case 1:
			control_calc(ap_pr);
		break;
		case 2:
			ap_pr.eps = atof(arg[3])/100;
			approx_value(ap_pr);
		break;
	}
}
