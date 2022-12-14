// Compute the control points and knot sequence a univariate B-Spline
// derivative.
//
// MATLAB SYNTAX:
//
//        [dc,dk] = bspderiv(d,c,k)
// 
// INPUT:
//
//   d - degree of the B-Spline
//   c - control points          double  matrix(mc,nc)
//   k - knot sequence           double  vector(nk)
//
// OUTPUT:
//
//   dc - control points of the derivative     double  matrix(mc,nc)
//   dk - knot sequence of the derivative      double  vector(nk)
//
//

#include "mexmat.h"

// Modified version of Algorithm A3.3 from 'The NURBS BOOK' pg98.
int bspderiv(int d, double *c, int mc, int nc, double *k, int nk, double *dc,
             double *dk)
{
  int ierr = 0;
  int i, j, tmp;

  // control points
  double **ctrl = vec2mat(c,mc,nc);

  // control points of the derivative
  double **dctrl = vec2mat(dc,mc,nc-1);
 
  for (i = 0; i < nc-1; i++) {
    tmp = d / (k[i+d+1] - k[i+1]);
    for (j = 0; j < mc; j++) {
      dctrl[i][j] = tmp * (ctrl[i+1][j] - ctrl[i][j]);
    }
  } 
  
  j = 0;
  for (i = 1; i < nk-1; i++)  
    dk[j++] = k[i];

  freevec2mat(dctrl);
  freevec2mat(ctrl);

  return ierr;
} 

// Matlab gateway function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  int mc, nc;
  int mk, nk;
  int mu, nu;

  int d;
  double *c, *p, *k, *dc, *dk;

  if (nrhs != 3)
    mexErrMsgTxt("Three inputs required\n");

  if (nlhs > 2)
    mexErrMsgTxt("Two output required maximum\n");

  // spline degree
  d = (int) mxGetScalar(prhs[0]);

  // control points
  c = mxGetPr(prhs[1]);
  mc = mxGetM(prhs[1]);
  nc = mxGetN(prhs[1]);

  // knot sequence
  k = mxGetPr(prhs[2]);
  mk = mxGetM(prhs[2]);
  nk = mxGetN(prhs[2]);

  // control points of the derivative
  plhs[0] = mxCreateDoubleMatrix(mc, nc-1, mxREAL);
  dc = mxGetPr(plhs[0]);

  // knot sequence of the derivative
  plhs[1] = mxCreateDoubleMatrix(mk, nk-2, mxREAL);
  dk = mxGetPr(plhs[1]);

  bspderiv(d, c, mc, nc, k, nk, dc, dk);
}



