/**********************************************************************
 * mvcubiceval_helper.h
 *
 * Richard Thompson <rthompson@mathworks.co.uk>
 * Time-stamp: <>
 ***********************************************************************/
#ifndef _MVCUBICEVAL_HELPER_H_
#define _MVCUBICEVAL_HELPER_H_

double recursiveEval(double evalIn, int currOrder, int startIndex, double *X, int *N, const double COEFFS[], int maxOrder, int *currPositionPtr);
double higherOrderEval(double evalIn, int maxInteractionOrder, int numFactors, double *Xi, double *X, int *N, const double COEFFS[], int maxOrder, int *currPositionPtr);



#endif /* _MVCUBICEVAL_HELPER_H_ */
