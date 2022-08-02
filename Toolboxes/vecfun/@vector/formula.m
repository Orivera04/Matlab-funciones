function str=formula(V)
%FORMULA  Vector function formulas.
%   FORMULA(V) returns the formulas for the vector function V.
%   The output is a string matrix with three rows.
%
%   See also EXPR, SIZE.

% Copyright (c) 2001-04-14, B. Rasmus Anthin.

fun=inputname(1);
[x y z xs ys zs]=vars(V);
if isempty(fun)
   fun='ans';
end
vars=['(' x ',' y ',' z ')'];equ=' = ';
str=char([fun '.' x vars xs equ V.fx],...
   [fun '.' y vars ys equ V.fy],...
   [fun '.' z vars zs equ V.fz]);