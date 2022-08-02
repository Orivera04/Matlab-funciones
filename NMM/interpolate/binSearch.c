/* File:  binSearch.c
 *
 *  C source code for MEX version of binary search routine
 *  G.W. Recktenwald,  5 Jan 1998
 */

#include <math.h>
#include "mex.h"

/* Input Arguments */
#define	X_IN        prhs[0]
#define	XHAT_IN     prhs[1]

/* Output Arguments */
#define	INDEX_OUT   plhs[0]

/* --------  prototypes for functions defined in this file */
unsigned int binSearch(double x[], unsigned int n, double xhat);


/* -------- Begin mexFunction(), the mex gateway to MATLAB -----------*/

void mexFunction(int nlhs,       mxArray *plhs[],
                 int nrhs, const mxArray *prhs[]
		        )
{
  double	*i,*x,*xhat;
  unsigned int	n;
  int rows, cols;

  /* Check for proper number of arguments */
  if (nrhs != 2) {
    mexErrMsgTxt("binSearch requires two input arguments.");
  } else if (nlhs > 1) {
    mexErrMsgTxt("binSearch requires one output argument.");
  }

  /* Create a matrix for the return argument */
  INDEX_OUT = mxCreateDoubleMatrix(1, 1, mxREAL);
  
  /* Assign pointers to the input and output parameters */
  i    = mxGetPr(INDEX_OUT);  
  x    = mxGetPr(X_IN);
  xhat = mxGetPr(XHAT_IN);
  
  rows = mxGetM(X_IN);   /*  Get number of rows in input matrix  */
  cols = mxGetN(X_IN);   /*  Get number of columns               */
  n = rows * cols;       /*  Total number of elements            */

  /*   The binSearch does the work and returns an unsigned int,
   *   which must be cast to double before assigning to i.
   *   Note that binSearch() returns the zero-offset index.
   *   Add one to that result to get proper MATLAB index,
   *   which is unit offset
   */
  *i = (double)(1+binSearch(x,n,*xhat));
  return;
}

/* ------------------ binSearch() --------------------------- */
/*
 *  Binary search to find index i such that x[i] <= xhat <= x[i+1]
 *
 *  Input:  x[]  = (double) vector of monotonic data
 *          n    = (unsigned int) length of x[]
 *          xhat = test value
 *
 *  Return:  i = index in x vector such that x[i]<= xhat <= x[i+1]
 *
 *  Note:   This C function returns the index in the zero-offset
 *          vector x.  Add one to the result to obtain the correct
 *          MATLAB index, which is unit-offset.
 */

unsigned int binSearch(double x[], unsigned int n, double xhat)
{
	unsigned int  ia,ib,im;
	
	ia = 0;   ib = n-1;     /*  Last element is n-1 for zero-offset vector  */
	while (ib-ia>1) {
	   im = (ia+ib) >> 1;   /*  Right shift by 1 is efficient integer divide by 2  */
	   if (x[im] < xhat) {
	     ia = im;           /*  Replace lower bracket  */
	   } else {
	     ib = im;           /*  Replace upper bracket  */
	   }
	}
	return ia;       /*  While loop terminates when ia is desired index  */
}
