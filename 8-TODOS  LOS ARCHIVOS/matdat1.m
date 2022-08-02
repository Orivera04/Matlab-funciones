%Data set #1 for matrix operations             last updated 6/16/94
%
%     Data are displayed and loaded. Memory is first cleared.
%
%     Use in the form:   ==> matdat1  <==
%
%  By: David R. Hill, Math. Department, Temple University,
%  Philadelphia, Pa. 19122, Email: hill@math.temple.edu

clear
clc

disp([blanks(23) 'Data Set #1 for Matrix Operations'])
disp(' ')

 A=[5 -2 1;1 0 4;-3 7 2];
 B=[2 2 3;-1 4 1;5 -3 0];
 C=[1 -1 2;0 1 4;-5 3 6];
 D=[-1 2 3;0 4 5];
 x =[-2 3 1]';
format compact,A,B,C,D,x,format loose

