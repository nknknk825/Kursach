
#ifndef FUNCT_H
#define FUNCT_H

void form_time(struct AppParams ap_pr, float* t);
void form_Uvx(struct AppParams ap_pr, float* Uvx, float* t);
void form_Uvix(struct AppParams ap_pr, float* Uvx, float* Uvix);
void form_tabl1(int n, float *t, float *Uvx, float *Uvix);

float parametr(int n, float dt, float *U);

#endif
