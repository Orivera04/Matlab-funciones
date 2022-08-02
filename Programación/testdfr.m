
% Test file testdfr.m.  
% Run on drawfr.m.

c1 = [-2 5];
A1=[1 1;-1 1;1 2];
rel1 = '><<';
b1 = [1;1;5];

c2 = [-1 1];
A2 = [1 1];
rel2 = '<';
b2 = 1;

c3 = [-3 5];
A3 = [-1 1;1 1;1 1;3 -1;1 -3];
rel3 = '<><<<';
b3 = [1;1;5;7;1];

c4 = [1 1];
A4 = [-1 1;-.1 1];
rel4 = '<<';
b4 = [1;2];
% Unbounded feasible region