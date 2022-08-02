/****************************************************************************
 fcs.c                                                      
                                                             
 MEX file to compute Fresnel integrals C(x) and S(x)        
                                                             
 The calling syntax is:                                     
                                                             
 [C, S] = fcs(x)     
 or
 F = fcs(x), where F = C+i*S
 
 Algorithm:
 This function uses an improved method for computing Fresnel integrals
 with an error of less then 1x10-9, described in:
 
 Klaus D. Mielenz, Computation of Fresnel Integrals. II
 J. Res. Natl. Inst. Stand. Technol. 105, 589 (2000), pp 589-590
 
 Notes for Linux implementation
 Compile this with:
 mex -O fcs.c
  
 Notes for Windows implementation
 Compile this with:
 mex -O fcs.c -DWIN32
                                                  */
/*
 Copyright (c) 2002 by Peter L. Volegov (volegov@unm.edu)   
 All Rights Reserved.                                       

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; 

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
                                                             
 *************************************************************************/

#include <math.h>
#include "mex.h"

/* Input Arguments */
#define	X prhs[0]

/* Output Arguments */
#define	C plhs[0]
#define S plhs[1]

#define TEYLOR_TERMS_NUM (11)
#define AUX_TERMS_NUM (12)
#define TEYLOR_THR (1.6)
#define PI (3.14159265358979323846)

void mexFunction(
                 int nlhs,       mxArray *plhs[],
                 int nrhs, const mxArray *prhs[]
		 )
{
	/* auxilary function coefficients */
	double fn[AUX_TERMS_NUM] = {0.318309844, 9.34636e-8, -0.09676631, 0.000606222, 
		                        0.325539361, 0.325206461, -7.450551455, 32.20380908,
					            -78.8035274, 118.5343352, -102.4339798, 39.06207702};
	double gn[AUX_TERMS_NUM] = {0, 0.101321519, -4.07292e-5, -0.152068115,
		                        -0.046292605, 1.622793598, -5.199186089, 7.477942354,
					            -0.695291507, -15.10996796, 22.28401942, -10.89968491};
	double cn[TEYLOR_TERMS_NUM], sn[TEYLOR_TERMS_NUM];

	int i, j, n2, n4, nElemNum;
	int nDimNum;
	const int *pDims;
	double *pX, *pC, *pS;
	const double pi2 = PI*PI;
	double x, xa, xn, yc, ys, f, g, sx, cx;
   
   /* Check for proper number of arguments, etc */
  if (nrhs < 1)
  {
	  mexPrintf("[C, S] = fcs(x) returns Fresnel integrals C ans S for argument x,\n");
	  mexPrintf("x must be double and real\n");
	  mexPrintf("Copyright (C) Peter Volegov 2002\n");
	  return;
  }
  else if(mxGetClassID(X) != mxDOUBLE_CLASS)
  {
	  mexErrMsgTxt("Input argument should be double");
	  return;
  }
  else if(mxIsComplex(X))
  {
	  mexErrMsgTxt("Input argument should be real (not complex)");
	  return;
  }


  /* Create output array */
  nDimNum = mxGetNumberOfDimensions(X);
  pDims = mxGetDimensions(X);

  if(nlhs < 2)
  {
	  C = mxCreateNumericArray(nDimNum, pDims, mxDOUBLE_CLASS, mxCOMPLEX);
	  pC = mxGetPr(C);
	  pS = mxGetPi(C);
  }
  else
  {
	  C = mxCreateNumericArray(nDimNum, pDims, mxDOUBLE_CLASS, mxREAL);
	  S = mxCreateNumericArray(nDimNum, pDims, mxDOUBLE_CLASS, mxREAL);
	  pC = mxGetPr(C);
	  pS = mxGetPr(S);
  }

  /* Calculate Teylor expansion coeffs */
  cn[0] = 1.0;
  sn[0] = PI/6;
  for(i = 0; i < TEYLOR_TERMS_NUM-1; i++)
  {
	  n2 = 2*i;
	  n4 = 2*n2;
	  cn[i+1] = -pi2*(n4+1)/(4*(n2+1)*(n2+2)*(n4+5))*cn[i];
	  sn[i+1] = -pi2*(n4+3)/(4*(n2+2)*(n2+3)*(n4+7))*sn[i];
  }

  nElemNum =  mxGetNumberOfElements(X);
  pX = mxGetPr(X);
  for(i = 0; i < nElemNum; i++)
  {
	  x = *pX++;
	  if(x<0.0)
		  xa = -x;
	  else
		  xa = x;
	  
	  if(xa < TEYLOR_THR)
	  {
		  /* Use Teylor approximation */
		  xn = xa*xa;
		  xn = xn*xn;
		  yc = cn[TEYLOR_TERMS_NUM-1];
		  ys = sn[TEYLOR_TERMS_NUM-1];
		  for(j = TEYLOR_TERMS_NUM-2; j >= 0; j--)
		  {
			  yc = cn[j]+xn*yc;
			  ys = sn[j]+xn*ys;
		  }
		  yc = xa*yc;
		  ys = xa*xa*xa*ys;

	  }
	  else
	  {
		  /* Use auxilary function approximation */
		  xn = xa*xa;
		  xn = 1/xn;
		  f = fn[AUX_TERMS_NUM-1];
		  g = gn[AUX_TERMS_NUM-1];
		  for(j = AUX_TERMS_NUM-2; j >= 0; j--)
		  {
			  f = fn[j]+xn*f;
			  g = gn[j]+xn*g;
		  }
		  f = f/xa;
		  g = g/xa;
		  
		  xn = PI/2*xa*xa;
		  cx = cos(xn);
		  sx = sin(xn);
		  
		  yc = 0.5 + f*sx - g*cx;
		  ys = 0.5 - f*cx - g*sx;
	  }

	  /* Copy to output variables */
	  if(x < 0.0)
	  {
		  *pC++ = -yc;
		  *pS++ = -ys;
	  }
	  else
	  {
		  *pC++ = yc;
		  *pS++ = ys;
	  }
  }
  
  return;
}

