function Y=expand(X)
%EXPAND  Expands expression in scalar function.
%   S = EXPAND(F) where F is a scalar function, returns a scalar function S,
%   so that S used implicitly in expressions like FUN(EXPAND(F)) results in
%   an expansion of F inside FUN(). E.g. F=x+y^2, SIN(F)="SIN(F)" but
%   SIN(EXPAND(F))="SIN(x+y^2)".

% Copyright (c) 2001-04-24, B. Rasmus Anthin.

Y=scalar(X);