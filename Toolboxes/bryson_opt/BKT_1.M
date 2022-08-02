function yp=bkt_1(t,y)
% Subroutine for Example 10.2.2;                               4/1/02
%
A=[-.254 -1.76 0 .322; 2.55 -.76 -.35 0; -9.08 2.19 -8.4 0; 0 0 1 0];
B=[.1246 -4.6 2.55 0]'; dr=25; 
yp=A*y+B*dr;