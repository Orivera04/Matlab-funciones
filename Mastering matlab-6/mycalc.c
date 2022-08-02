/*
 * mycalc.c - calculates x^2 - x + 1/x for each element of an array.
 *
 *   MATLAB usage:   p = mycalc(n)
 *
 *   Mastering MATLAB MEX Example 2: 
 *       single 2-D real numeric array input, 
 *       single array output.
 */

/*   B.R. Littlefield, University of Maine, Orono, ME 04469
 *   7/13/00
 *   Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9
 */

#include "mex.h"

/* This is the original subroutine that does the calculation. */

static void mycalc( double p[], double n[], int r, int c)
{
    int i;
    for (i = 0; i < r*c; i++)
        p[i] = n[i]*n[i]-n[i]+1.0/n[i];
}

/* This is the interface to MATLAB data types and arguments. */

void mexFunction( int nlhs,       mxArray *plhs[], 
		          int nrhs, const mxArray *prhs[] )
{ 
    double *p, *n; 
    int  r, c; 
    
    /* Do some error checking. */

    if (nrhs != 1)    
      mexErrMsgTxt("One input argument required."); 
    else if (nlhs > 1) 
      mexErrMsgTxt("Too many output arguments."); 
    else if (!mxIsNumeric(prhs[0]))
      mexErrMsgTxt("Input must be numeric."); 
    else if (mxIsComplex(prhs[0]))
      mexErrMsgTxt("Input must be real."); 
    else if (mxGetNumberOfDimensions(prhs[0]) > 2)
      mexErrMsgTxt("N-Dimensional arrays are not supported."); 
    
    /* Get the input array dimensions. */

    r = mxGetM(prhs[0]); 
    c = mxGetN(prhs[0]);

    /* Create a matrix for the return argument */ 

    plhs[0] = mxCreateDoubleMatrix(r, c, mxREAL); 
    
    /* Assign pointers to the parameters */ 

    p = mxGetPr(plhs[0]);
    n = mxGetPr(prhs[0]);

    /* Do the actual calculation in a subroutine. */

    mycalc(p, n, r, c); 
}

