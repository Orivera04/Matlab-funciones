
% File cpa.m (Examples used to test Gomory's cutting plane algorithm)

type1 = 'min';
c1 = [1 -3];
A1 = [1 -1;2 4];
b1 = [2;15];

% Optimal solution:
% x1 = 0; x2 = 3; z = -9

type2 = 'min';
c2 = [1 -2];
A2 = [2 1;-4 4];
b2 = [5;5];

% Optimal solution:
% x1 = 1; x2 = 2; z = -3

type3 = 'min';
c3 = [1 -1];
A3 = [3 4;1 -1];
b3 = [6;1];

% Optimal solution:
% x1 = 0; x2 = 1; z = -1

type4 = 'max';
c4 = [1 2];
A4 = [1 3;2 -1];
b4 = [13;6];

% Optimal solution:
% x1 = 4; x2 = 3; z = 10

type5 = 'max';
c5 = [1 3];
A5 = [-1 3;2 1];
b5 = [6;12];

% Optimal solution:
% x1 = 4; x2 = 3; z = 13

type6 = 'max';
c6 = [8 15];
A6 = [10 21;2 1];
b6 = [156;22];

% Optimal solution:
% x1 = 9, x2 = 3, z = 117

type7 = 'max';
c7 = [3 13];
A7 = [2 9;11 -8];
b7 = [40;82];

% Optimal solution:
% x1 = 2; x2 = 4; z = 58  (Function cpa fails to compute this solution)
