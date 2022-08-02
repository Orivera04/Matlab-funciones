
% File testaddc.m (Examples used to test function addconstr.m)

type1 = 'max';
A1 = [-2 0 5 1 2 -1 6;11 1 -18 0 -7 4 4;3 0 2 0 2 1 106];
subs1 = [4;2];
a1 = [3 1 0 3];
rel1 = '<';
d1 = 20;

% Finite optimal solution:
% x1 = x2 = x5 = x6 = 0
% x3 = 2/3, x4 = 20/3, z = 302/3.
                 
type2 = 'max';
A2 = [-2 0 5 1 2 -1 6;11 1 -18 0 -7 4 4;3 0 2 0 2 1 106];
subs2 = [4;2];
a2 = [4 1 0 4];
rel2 = '>';
d2 = 29;

% Empty feasible region
