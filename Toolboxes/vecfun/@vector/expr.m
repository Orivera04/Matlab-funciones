function str=expr(V)
%EXPR  Vector function eval expressions.
%   EXPR(V) returns the expressions for the vector function V
%   to be evaluated.
%   The output is a string matrix with three rows.
%
%   See also FORMULA, SIZE.

% Copyright (c) 2001-04-14, B. Rasmus Anthin.

str=char(V.Fx,V.Fy,V.Fz);