
#ifndef FUNCT_H
#define FUNCT_H

void form_time(struct AppParams ap_pr, float* t);
void form_Uvx(struct AppParams ap_pr, float* Uvx, float* t);
void form_Uvix(struct AppParams ap_pr, float* Uvx, long double* Uvix);
void form_tabl1(int n, float *t, float *Uvx, long double* Uvix);

float parametr(int n, float sum, long double *Uvix, float *t);

void file_out_data(int n, float* t, float* Uvx, long double* Uvix);

void control_calc(struct AppParams ap_pr);
void approx_value(struct AppParams ap_pr);

#endif
