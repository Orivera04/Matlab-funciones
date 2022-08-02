function y=range(V)
%RANGE  The range is the difference between the maximum and minimum values.
%   y = RANGE(V) calculates the ranges of the vector function
%   components V.x, V.y and V.z.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

y=max(V)-min(V);