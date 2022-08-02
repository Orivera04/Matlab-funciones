% P5_16.M Solve the equation D2y+3*Dy+2*y = U(t)
%   from t=0 to t=10 for the unit step input 
%  (Requires Symbolic Math Toolbox)
%
clear
y1=dsolve('D2y+3*Dy+2*y=1','y(0)=0','Dy(0)=0','t')
%
clf
ezplot(y1,[0,10]);	
title('Solution to D2y+3*Dy+2*y=U(t)')
ylabel('y(t)')
zoom
 