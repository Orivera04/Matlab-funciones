// Basis Function. 
//
// INPUT:
//
//   i - knot span  ( from FindSpan() )
//   u - parametric point
//   p - spline degree
//   U - knot sequence
//
// OUTPUT:
//
//   N - Basis functions vector[p+1]
//
// Algorithm A2.2 from 'The NURBS BOOK' pg70.

void basisfun(int i, double u, int p, double *U, double *N)
{
  int j,r;
  double saved, temp;

  // work space
  double *left  = (double*) mxMalloc((p+1)*sizeof(double));
  double *right = (double*) mxMalloc((p+1)*sizeof(double));
  
  N[0] = 1.0;
  for (j = 1; j <= p; j++)
  {
    left[j]  = u - U[i+1-j];
    right[j] = U[i+j] - u;
    saved = 0.0;
    
    for (r = 0; r < j; r++)
    {
      temp = N[r] / (right[r+1] + left[j-r]);
      N[r] = saved + right[r+1] * temp;
      saved = left[j-r] * temp;
    } 

    N[j] = saved;
  }
  
  mxFree(left);
  mxFree(right);
}
