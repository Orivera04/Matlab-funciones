function result = one ( x )
%
%  We would normally write "result = 1.0".
%
%  But if x is a vector, we want to return a vector, and "result=1.0" won't
%  do that.
%
result = ones ( size ( x ) );
