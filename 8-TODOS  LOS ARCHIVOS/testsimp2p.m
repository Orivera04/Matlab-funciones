
% File testsimp2p.m (Examples used to test the Two-Phase Method)
% Run on simplex2p.

type1 = 'min';
c1 = [-.5 -.4];
A1 = [5 1;1 2; 1 2];
rel1 = '<<<';
b1 = [10;24;11];

% Finite optimal solution:
% x1=1, x2=5, z= -2.5

type2 = 'max';
c2 = [1 2 3 -1];
A2 = [2 1 5 0;1 2 3 0;1 1 1 1];
rel2 = '<<<';
b2 = [20;25;10];

% Finite optimal solution:
% x1=0, x2=7.5, x3=2.5, z=22.5

type3 = 'max';
c3 = [3 2 1];
A3 = [2 -3 2;-1 1 1];
rel3 = '<<';
b3 = [3;55];

% Unbounded objective function

type4 = 'max';
c4 = [1 1 -1];
A4 = [1 -2 1;2 1 -1];
rel4 = '<<';
b4 = [1;4];

% Finite optimal solution:
% x1=0, x2=4, x3=0, z=4

type5 = 'min';
c5 = [-3 4];
A5 = [1 1;2 3];
rel5 = '<>';
b5 = [4;18];

% Empty feasible region

type6 = 'min';
c6 = [1 -2];
A6 = [1 1;-1 1;0 1];
rel6 = '>><';
b6 = [2 1 3];

% Finite optimal solution:
% x1=0, x2=3, z= -6

type7 = 'min';
c7 = [-1 2 -3];
A7 = [1 1 1;-1 1 2;0 2 3;0 0 1];
rel7 = '===<';
b7 = [6 4 10 2];





% Redundant system. Optimal solution:
% x1=x2=x3=2, z= -4

type8 = 'min';
c8 = [3 4 6 7 1 0 0];
A8 = [2 -1 1 6 -5 -1 0;1 1 2 1 2 0 -1];
rel8 = '==';
b8 = [6;3];

% Finite optimal solution:
% x1=3, x2 = ... = x7=0, z=9

type9 = 'min';
c9 = [1 2];
A9 = [1 1;2 2];
rel9 = '==';
b9 = [2;4];

% Redundant system. Optimal solution:
% x1=2, x2=0, z=2

type10 = 'min';
c10 = [-1 0];
A10 = [-2 1;-1 1;1 0];
rel10 = '<<<';
b10 = [2;3;3];

% Nonunique optimal solution:
% x1=3, x2=0 (or 6), z= -3

type11 = 'min';
c11 = [2 3];
A11 = [3 2;2 -4;4 3];
rel11 = '=><';
b11 = [14;2;19];

% Finite optimal solution:
% x1=14/3, x2=0, z=28/3

type12 = 'min';
c12 = [-1 -1];
A12 = [1 0;1 1];
rel12 = '<<';
b12 = [2;2];

% Degenerate problem. Finite optimal solution:
% x1=2, x2=0, z= -2

type13 = 'min';
c13 = [-3/4 150 -1/50 6];
A13 = [1/4 -60 -1/25 9;1/2 -90 -1/50 3;0 0 1 0];
rel13 = '<<<';
b13 = [0 0 1];

% Example of cycling. Finite optimal solution: 
% x1=2/50, x2=0, x3=1, x4=0, z= -1/20

type14 = 'min';
c14 = [-2 -4];
A14 = [1 2 1 0;-1 1 0 1];
rel14 = '==';
b14 = [4;1];

% Nonunique optimal solution:
% x1=4, x2=0 or x1=2/3, x2=5/3, z=-8