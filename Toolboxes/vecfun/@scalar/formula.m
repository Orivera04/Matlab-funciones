function str=formula(S)
%FORMULA  Scalar function formula.
%   FORMULA(S) returns the formula for the vector function S.
%
%   See also EXPR, SIZE.

% Copyright (c) 2001-04-14, B. Rasmus Anthin.

fun=inputname(1);
if isempty(fun)
   fun='ans';
end
[x y z]=vars(S);
str=[fun '(' x ',' y ',' z ') = ' S.f];