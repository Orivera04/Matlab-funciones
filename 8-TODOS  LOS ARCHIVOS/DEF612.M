
% A program of type function
% Program name is def612.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% This function defines the differential equation required to be solved in  question 12 of chapter 6
% the differential equation  " y''' = - 6y4".
%
function dy=def612(t,y)
dy=[y(2);y(3);-6*y(1)^4]