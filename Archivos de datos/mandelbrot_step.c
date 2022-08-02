#include <math.h>
#include "mex.h"
void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray *prhs[] )

/* function [z,kz] = mandelbrot_step(z,kz,z0,d);
 * Take one step of the Mandelbrot iteration.
 * Complex arithmetic:
 *    z = z.^2 + z0
 *    kz(abs(z) < 2) == d
 * Real arithmetic:
 *    x <-> real(z);
 *    y <-> imag(z);
 *    u <-> real(z0);
 *    v <-> imag(z0);
 *    [x,y] = [x.^2-y.^2+u, 2*x.*y+v];
 *    kz(x.^2+y.^2 < 4) = d;
 */
     
{ 
    double *x,*y,*u,*v,t; 
    unsigned short *kz,d;
    int j,n; 
    
    x = mxGetPr(prhs[0]); 
    y = mxGetPi(prhs[0]);
    kz = (unsigned short *) mxGetData(prhs[1]); 
    u = mxGetPr(prhs[2]); 
    v = mxGetPi(prhs[2]);
    d = (unsigned short) mxGetScalar(prhs[3]);
    plhs[0] = prhs[0];
    plhs[1] = prhs[1];

    n = mxGetN(prhs[0]);
    for (j=0; j<n*n; j++) {
        if (kz[j] == d-1) {
            t = x[j];
            x[j] = x[j]*x[j] - y[j]*y[j] + u[j];
            y[j] = 2*t*y[j] + v[j];
            if (x[j]*x[j] + y[j]*y[j] < 4) {
                kz[j] = d;
            }
        }
    }
    return;
}
