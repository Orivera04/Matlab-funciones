// Find the knot span of the parametric point u. 
//
// INPUT:
//
//   n - number of control points - 1
//   p - spline degree       
//   u - parametric point    
//   U - knot sequence
//
// RETURN:
//
//   s - knot span
//
// Algorithm A2.1 from 'The NURBS BOOK' pg68

int findspan(int n, int p, double u, double *U)
{
  int low, high, mid;
   
  // special case
  if (u == U[n+1]) return(n);
    
  // do binary search
  low = p;
  high = n + 1;
  mid = (low + high) / 2;
  while (u < U[mid] || u >= U[mid+1])
  {
    if (u < U[mid])
      high = mid;
    else
      low = mid;
    mid = (low + high) / 2;
  }  

  return(mid);
}

