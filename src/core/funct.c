#include <stdio.h>
#include <math.h>

#include "globals.h"
#include "funct.h"

void form_time(struct AppParams ap_pr, float* t) {
	float dt = (ap_pr.tk - ap_pr.tn) / (ap_pr.n - 1);
	for (int i = 0; i < ap_pr.n; i++) {
		t[i] = ap_pr.tn + i * (dt);
	}
}

void form_Uvx(struct AppParams ap_pr, float* t, float* Uvx) {
	for (int i = 0; i < ap_pr.n; i++) {
		if (t[i] < ap_pr.t1) {
        	Uvx[i] = ap_pr.a * (t[i] - ap_pr.tn);
		} else {
        	Uvx[i] = ap_pr.a * (ap_pr.t1 - ap_pr.tn) - ap_pr.b * (t[i] - ap_pr.t1);
		}
	}
}

void form_Uvix(struct AppParams ap_pr, float* Uvx, float* Uvix) {
	for (int i = 0; i < ap_pr.n; i++) {
		if (Uvx[i] < ap_pr.Uvx1) {
			Uvix[i] = ap_pr.U1;
        } else if (Uvx[i] <= ap_pr.Uvx2) {
			Uvix[i] = 6.5 * Uvx[i] - 12.5;
        } else {
			Uvix[i] = ap_pr.U2;
		}
	}
}

void form_tabl1(int n, float* t, float* Uvx, float* Uvix) {
	for (int i = 0; i < n; i++) {
		if (i<(n-1)) printf("%g ", t[i]);
		else printf("%g\n",t[i]);
	}

    for (int i = 0; i < n; i++) {
        if (i<(n-1)) printf("%g ", Uvx[i]);
        else printf("%g\n",Uvx[i]);
    }

    for (int i = 0; i < n; i++) {
        if (i<(n-1)) printf("%g ", Uvix[i]);
        else printf("%g\n",Uvix[i]);
    }
	printf("№ t Uvx Uvix\n");
    for (int i = 0; i < n; i++) {
        printf("%d %g %g %g\n", i, t[i], Uvx[i], Uvix[i]);
    }
}
