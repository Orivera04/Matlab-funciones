// Useful functions for accessing and manipulating matlab data structures.
// =======================================================================

#include "mexmat.h"

// convert c vector to c matrix.
double **vec2mat(double *vec, int nrows, int ncols) 
{
  int col;
  double **mat;

  mat = (double**) mxMalloc (ncols*sizeof(double*));
  mat[0] = vec;
  for (col = 1; col < ncols; col++)
    mat[col] = mat[col-1] + nrows;  
  return mat;
}

// create a new c matrix
double **matrix(int nrows, int ncols) 
{
  int col;
  double **mat;

  mat = (double**) mxMalloc (ncols*sizeof(double*));
  mat[0] = (double*) mxMalloc (nrows*ncols*sizeof(double));
  for (col = 1; col < ncols; col++)
    mat[col] = mat[col-1] + nrows;  
  return mat;
}

void freevec2mat(double **mat)
{
  mxFree(mat);
}

void freematrix(double **mat)
{
  mxFree(mat[0]);
  mxFree(mat);
}


