% List4_2 illustrate an application of  Lagran_ 
% for Lagrange interpolation.
% Copyright S. Nakamuram, 1995
clear
x = [1.1, 2.3, 3.9, 5.1];
y=[3.887, 4.276, 4.651, 2.117];
xi = [2.101, 4.234];
yi = Lagran_(x, y, xi);
format short
disp '    xi        yi'
disp([xi; yi]')
