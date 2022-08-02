/* 
* $Revision: 1.3 $ 
* Copyright 2000-2003 The MathWorks, Inc. and Ford Global Technologies, Inc.
*/

double * phi_calc (int poly_order, double x, int num_knots, double* K, double* B0, double* B1, double* limits);

void eval_loop(double *x, double *phi, double *c, double *n, int interact, int phiC, double *y);

void SetKnot(double *K, int poly_order, double *knots, int num_knots, double* limits);
