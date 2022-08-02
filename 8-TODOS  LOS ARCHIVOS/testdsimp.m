
% File testdsimp.m (Examples used to test the Dual Simplex Algorithm)
% Run on function dsimplex.

type1 = 'min';
c1 = [-.5 -.4];
A1 = [5 1;1 2; 1 2];
b1 =[10;24;11];

% Finite optimal solution:
% x1 = 24, x2 = 0, z = -12

type2 = 'max';
c2 = [1 2 3 -1];
A2 = [2 1 5 0;1 2 3 0;1 1 1 1];
b2 = [20;25;10];

% Finite optimal solution:
% x2 = 20, x1 = x3 = x4 = 0, z = 40

type3 = 'max';
c3 = [3 2 1];
A3 = [2 -3 2;-1 1 1];
b3 = [3;55];

% Finite optimal solution:
% x1 = 0, x2 = 21.4, x3 = 33.6, z = 76.4

type4 = 'max'; 
c4 = [1 1 -1];
A4 = [1 -2 1;2 1 -1];
b4 = [1;4];

% Finite optimal solution:
% x1 = 1.8, x2 = 0.4, x3 = 0, z = 2.2 

type5 = 'min';
c5 = [2 3 4];
A5 = [1 2 1;2 -1 3];
b5 = [3;4];

% Finite optimal solution:
% x1 = 11/5, x2 = 2/5, z = 28/5

type6 = 'min';
c6 = [-2 3 4];
A6 = [-1 -1 -1;2 2 2];
b6 = [-1;4];

% Empty feasible region
