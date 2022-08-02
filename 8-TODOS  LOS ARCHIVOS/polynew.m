function root = polynew ( c, x )
%
FATOL = 0.00001;
XATOL = 0.00001;
ITMAX = 20;

for IT = 1:ITMAX

  [ fx, fp ] = horner ( c, x );

  if ( abs ( fx ) <= FATOL )
    root = x;
    return
  end 

  if ( fp == 0 )
    'Error, C = 0'
    root = x;
    return
  end

  xnew = x - fx / fp;
  
  if ( abs ( xnew - x ) <= XATOL ) 
    root = xnew;
    return
  end 

  x = xnew;

end

'Too many iterations in POLYNEW'
root = x;
