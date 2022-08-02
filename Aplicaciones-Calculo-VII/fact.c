/*
 * fact.c - returns the factorial of a non-negative integer.
 *
 *   MATLAB usage:   p = fact(n)
 *
 *  Mastering MATLAB 7 C MEX Example 1
 */

#include "mex.h"

void mexFunction( int nlhs,       mxArray *plhs[],
              int nrhs, const mxArray *prhs[] )
{
    double n, j, *p;
    int i;

    n = mxGetScalar(prhs[0]);
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    p = mxGetPr(plhs[0]);

    j = 1.0;
    for (i = n; i > 1; i--)
        j = j * i;
    *p = j;
}
