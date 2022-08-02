function Y=expand(X)
%EXPAND  Expands expression in vector function.
%   V = EXPAND(F) where F is a vector function, returns a scalar function V,
%   so that V used implicitly in expressions like FUN(EXPAND(F)) results in
%   an expansion of F inside FUN(). E.g. F=[-y,x,0], SIN(F)="SIN(F)" but
%   SIN(EXPAND(F))="SIN([-y,x,0])".

% Copyright (c) 2001-04-24, B. Rasmus Anthin.

Y=vector(X);