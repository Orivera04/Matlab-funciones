% P3_27.M Test function vrot
%   Calls function vrot
%
x1=[1 0]'       % [1 0] rotated 30 degrees
y1=vrot(x1,30) % [1 0] rotated 30 degrees
pause
x2=[0 1]'    
y2=vrot(x2,30)
pause
%
% Misc. test
%
y3=vrot(y2,-30)  % Rotate y2 back (=x2?)
%
%  Add a few comments and test this M-file with 
%   format short and format long
%


