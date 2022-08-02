function y = shuffle(x)

% shuffle - shuffle at random an array of numbers.
%
%   y = shuffle(x);
%
%   Copyright (c) 2004 Gabriel Peyr�

y = x( randperm(length(x)) );