% Script p1_2_21.m; shortest distance to a line in 3-D; 
% w=[x y z la1 la2]';                           1/93, 9/10/98
%
A=[1 2 3 0 0; 1 -1 2 0 0; 2 0 0 1 1; 0 2 0 2 -1; 0 0 2  3 2];
b=[10 10 0 0 0]'; w=A\b; v=w([1:3]); d=norm(v);
disp('      x          y         z         d');
disp([v' d]);
% Answer: w =[1.6949 -1.1864  3.5593 -0.3390 -3.0508]';
% d = 4.1169
