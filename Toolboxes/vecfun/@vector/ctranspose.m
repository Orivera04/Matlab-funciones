function y=ctranspose(x)
%CTRANSPOSE  Derivation operator
%   GRAD for scalars
%   DIV for vectors

% Copyright (c) 2001-08-22, B. Rasmus Anthin.

y=div(x,inputname(1));