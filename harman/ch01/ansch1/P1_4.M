% P1_4.M  Create a table of x^2, x^3, and x^4
clear
x=[0:10]';	% This creates a column of numbers
powerofx=[x  x.^2  x.^3  x.^4];
disp('           x          x^2         x^3         x^4')
disp(powerofx)
% Note:  x=0:10;  [x;x.^2;x.^3;x.^4]' will work also            
