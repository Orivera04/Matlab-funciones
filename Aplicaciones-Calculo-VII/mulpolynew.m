function roots = mulpolynew ( c, x )
%
FATOL = 0.00001;
XATOL = 0.00001;
ITMAX = 10;

roots = [];
n = size ( c, 2 );

for it = 1 : n-1

  new_root = polynew ( c, x );
  roots = [ roots, new_root ];

  [ c, rem ] = horner_factor ( c, new_root );

  if ( abs ( rem ) > 0.0001 ) 
    'Something is wrong!'
    return
  end 

end

'Got them all!'
