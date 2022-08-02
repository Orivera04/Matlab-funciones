function result = slinky ( x )
%  SLINKY computa el seno de ( x ) / x.
%
if ( x == 0 )
  result = 1;
else
  result = sin ( x ) ./ x;
end