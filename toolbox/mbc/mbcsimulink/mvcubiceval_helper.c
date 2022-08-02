/*
 * evalIn       partial evaluation
 * currOrder    current level of recursion (= current poly order)
 * startIndex   starting value for loop
 * X            inputs to evaluate
 * N 
 * COEFFS       model coefficients
 * maxOrder     Maximum order to evaluate
 * currPosition Current position in coeff array
 */

/*  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc. */

/*  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:02:52 $ */

double recursiveEval(double evalIn, int currOrder, int startIndex, double *X, int *N, 
                     double COEFFS[], int maxOrder, int *currPositionPtr)
{
  int i;
  double y;

  for (i = startIndex; i < N[currOrder]; i++) {
    /* this switch takes care of interaction=0 case */
    if (maxOrder >= 0) { 

      (*currPositionPtr)++;
      if (currOrder < maxOrder) {
        // increase poly order (level)
        y = recursiveEval(COEFFS[*currPositionPtr], currOrder+1, i, X, N, COEFFS, maxOrder, currPositionPtr);
      } else {
        y = COEFFS[*currPositionPtr];
      }
      evalIn += X[i]*y;
    }
  }
  return evalIn;
}


double higherOrderEval(double evalIn, int maxOrder, int numFactors, double *Xi, double *X, int *N, 
                       double COEFFS[], int maxInteractionOrder, int *currPositionPtr)
{
        int i;
        int j;
        double * lX;
        double * lXi;

        // Get a local copy of the input factors for iteration
        
        for (i = 0, lXi = Xi; i < numFactors; i++) {
          *lXi++ = 1.0;
        }

        for (i = 0; i < maxOrder; i++) {
                // Multiply every member of Xi by X - Xi = Xi.*X
          for (j = 0, lX = X, lXi = Xi; j < numFactors; j++) {
            (*lXi++) *= (*lX++);
          }
          if (i > maxInteractionOrder) {
            for (j = 0, lXi = Xi; j < N[i]; j++) {
              (*currPositionPtr)++;
              evalIn += COEFFS[*currPositionPtr] * (*lXi++);
            }
          }
        }

        return evalIn;
}
