%  determ_data.m
% This file contains the matrix definitions which are needed for the Determinants module.

format rat
A=[2 -6 0 6;5 -7 8 2;-3 -2 4 1;5 -1 4 -1];
B=[4 20 -29 25;3 13 -24 13 ;1 5 -7 4;5 25 -35 21];
I4=eye(4);
I9=eye(9);
Z4=zeros(4);
Z9=zeros(9);
R=fix(-10+rand(7)*20);
S=fix(-10+rand(7)*20);
P=fix(-10+rand(4)*20);
K=[3 1 -2 5;-2 6 -15 2;8 -5 7 9;5 -6 9 4];
U=[2 -9 23 5;0 -3 4 33;0 0 1 71;0 0 0 5];
L=[15 0 0 0;27 1 0 0;34 9 6 0;99 7 45 -1];
T =fix(-10+rand(4)*20);
H = hilb(3);
