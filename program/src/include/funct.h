
#ifndef FUNCT_H
#define FUNCT_H

void form_time(float* t, int n);
void form_Uvx(float* Uvx, float* t, int n);
void form_Uvix(float* Uvx, float* Uvix, int n);
void form_tabl1(int n, float *t, float *Uvx, float *Uvix);

float parametr(int n, float sum, float *U, float *t);

void file_out_data(int n, float* t, float* Uvx, float* Uvix);

void control_calc(int n, int eps);
void approx_value(int n, int eps);

#endif
