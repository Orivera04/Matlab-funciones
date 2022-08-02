// Useful functions for accessing and manipulating matlab data structures.
// =======================================================================

#ifndef __MEXMAT_H
#define __MEXMAT_H

#include <math.h>
#include "mex.h"

double **vec2mat(double *vec, int nrows, int ncols);
double **matrix(int nrows, int ncols);
void freevec2mat(double **mat);
void freematrix(double **mat);

#endif // __MEXMAT_H

