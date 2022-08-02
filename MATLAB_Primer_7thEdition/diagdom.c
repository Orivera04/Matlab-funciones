#include "mex.h"
#include "matrix.h"
#include <stdlib.h>
#include <float.h>
#define INDEX(i,j,m) ((i)+(j)*(m))
#define ABS(x) ((x) >= 0 ? (x) : -(x))
#define MAX(x,y) (((x)>(y)) ? (x):(y))

void diagdom
(
    double *A, int n, double *B,
    double tol, int *List, int *nList
)
{
    double d, a, f, bij, bii ;
    int i, j, k ;
    for (k = 0 ; k < n*n ; k++)
    {
        B [k] = A [k] ;
    }
    if (tol < 0)
    {
        tol = 100 * DBL_EPSILON ;
    }
    k = 0 ;
    for (i = 0 ; i < n ; i++)
    {
        d = B [INDEX (i,i,n)] ;
        a = ABS (d) ;
        f = 0 ;
        for (j = 0 ; j < n ; j++)
        {
            if (i != j)
            {
                bij = B [INDEX (i,j,n)] ;
                f += ABS (bij) ;
            }
        }
        if (f >= a)
        {
            List [k++] = i ;
            bii = (1 + tol) * MAX (f, tol) ;
            if (d < 0)
            {
                bii = -bii ;
            }
            B [INDEX (i,i,n)] = bii ;
        }
    }
    *nList = k ;
}

void error (char *s)
{
    mexPrintf
    ("Usage: [B,i] = diagdom (A,tol)\n") ;
    mexErrMsgTxt (s) ;
}

void mexFunction
(
    int nargout, mxArray *pargout [ ],
    int nargin,  const mxArray *pargin [ ]
)
{
    double tol, *A, *B, *I ;
    int n, k, *List, nList ;

    /* get inputs A and tol */
    if (nargout > 2 || nargin > 2 || nargin==0)
    {
        error ("Wrong number of arguments") ;
    }
    if (mxIsSparse (pargin [0]))
    {
        error ("A cannot be sparse") ;
    }
    n = mxGetN (pargin [0]) ;
    if (n != mxGetM (pargin [0]))
    {
        error ("A must be square") ;
    }
    A = mxGetPr (pargin [0]) ;
    tol = -1 ;
    if (nargin > 1)
    {
        if (!mxIsEmpty (pargin [1]) &&
           mxIsDouble (pargin [1]) &&
           !mxIsComplex (pargin [1]) && 
           mxIsScalar (pargin [1]))
        {
            tol = mxGetScalar (pargin [1]) ;
        }
        else
        {
            error ("tol must be scalar") ;
        }
    }

    /* create output B */
    pargout [0] =
        mxCreateDoubleMatrix (n, n, mxREAL) ;
    B = mxGetPr (pargout [0]) ;

    /* get temporary workspace */
    List = (int *) mxMalloc (n * sizeof (int)) ;

    /* do the computation */
    diagdom (A, n, B, tol, List, &nList) ;

    /* create output I */
    pargout [1] =
        mxCreateDoubleMatrix (nList, 1, mxREAL);
    I = mxGetPr (pargout [1]) ;
    for (k = 0 ; k < nList ; k++)
    {
        I [k] = (double) (List[k] + 1) ;
    }

    /* free the workspace */
    mxFree (List) ;
}
