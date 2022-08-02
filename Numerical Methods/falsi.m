function root = falsi ( f, a, b )

XATOL = 0.000001;
ITMAX = 20;

fa = feval ( f, a ); 
fb = feval ( f, b );

format long

it = 0

%
%  Note that we can't guarantee that the interval will get 
%  smaller as we increase the number of iterations.  For instance,
%  if the function is convex near the root, one endpoint of the
%  interval may get stuck, while the other approaches the root.
%
%  So we don't want to require iteration until the interval is
%  small, but we can exit early if it does happen to become small.
%
%  Thanks to Professor Janet Peterson for pointing out this issue.
%
while ( abs ( b - a ) > XATOL | it <= ITMAX )

  it = it + 1;

  c = ( fb * a - fa *  b ) / ( fb - fa );
  fc = feval ( f, c );

  [  a,  c,  b ;
    fa, fc, fb ]

  if ( fc == 0 ) 
    root = c;
    return
  elseif ( sign ( fc ) == sign ( fa ) )
    a = c;
    fa = fc;
  elseif ( sign ( fc ) == sign ( fb ) )
    b = c;
    fb = fc;
  end

  pause

end

root = c;
