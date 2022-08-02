/*
 * count.c - count occurances of values in an array.
 *
 *   MATLAB usage:   c = count(a,b,tol);
 *
 *   count(A,B) returns an array the same size as A whose 
 *   i-th element contains the number of times A(i) appears 
 *   in the array B. A and B must be Real arrays.
 *
 *   count(A,B,TOL) counts occurances that are within +/- TOL 
 *   of each other.
 *
 *   This MEX file implements the functionality of the 
 *   Mastering MATLAB Toolbox function mmcount.
 *   
 *   Mastering MATLAB MEX Example 5:
 *       two numeric array inputs, 
 *       one optional scalar double input,
 *       one double array output,
 */

/*   B.R. Littlefield, University of Maine, Orono, ME 04469
 *   6/22/00
 *   Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9
 */

#include <math.h>
#include "mex.h"

/* Define some variables to make life easier. */

#define A   prhs[0]    /* Pointer to first right-hand-side argument */
#define B   prhs[1]    /* Pointer to second right-hand-side argument */
#define TOL prhs[2]    /* Pointer to third right-hand-side argument */
#define C   plhs[0]    /* Pointer to first left-hand-side argument  */

void  mexFunction( int nlhs,       mxArray *plhs[],
                   int nrhs, const mxArray *prhs[] )

{
    int i, j, sizea, sizeb;
    double tol, vcount;
    double *a, *b, *c;

    /* Do some error checking */

    if (nrhs < 2)
        mexErrMsgTxt("Missing input arguments.");
    else if (nrhs > 3)
        mexErrMsgTxt("Too many input arguments.");
    else if (nlhs > 1)
        mexErrMsgTxt("Too many output arguments.");

    /* Get tolerance value if supplied, otherwise use EPS. */

    if (nrhs == 3) {
        if (!mxIsNumeric(TOL) || mxIsComplex(TOL) ||
            mxGetNumberOfElements(TOL) != 1 )
            mexErrMsgTxt("TOL must be a real numeric scalar.");
        tol = mxGetScalar(TOL);
        if (tol < mxGetEps())
            mexErrMsgTxt("TOL must be a positive value.");
    }
    else 
        tol = mxGetEps();
    
    /* Make sure input arrays are non-complex numeric arrays. */

    if (!mxIsNumeric(A) || !mxIsNumeric(B) ||
        mxIsComplex(A) || mxIsComplex(B)) 
        mexErrMsgTxt("Input arguments must be real of type double.");

    /* Create the output mxArray the same size as A */

    C = mxCreateNumericArray(mxGetNumberOfDimensions(A),
          mxGetDimensions(A), mxDOUBLE_CLASS, mxREAL);

    /* Get the number of elements in A and B and create pointers */
    /* to the input and output arrays. */

    sizea = mxGetNumberOfElements(A);
    sizeb = mxGetNumberOfElements(B);
    a = (double *) mxGetPr(A);
    b = (double *) mxGetPr(B);
    c = (double *) mxGetPr(C);

    /* Cycle through the elements of the arrays and count values */

    for (i = 0; i < sizea; i++) {
        vcount = 0.0;
        for (j = 0; j < sizeb; j++)
        if ((fabs(a[i] - b[j])) <= tol)
            vcount++;
        c[i] = vcount;
    }

}
