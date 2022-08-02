% P5_17.M Solve the equation D3y+8*D2y+37*Dy+50*y = 4*exp(-3*t)
%   with y(0)=1, Dy(0)=2, D2y(0)=1 in the range [0,2]
%  (Requires Symbolic Math Toolbox)
%
clear
y1=dsolve('D3y+8*D2y+37*Dy+50*y=4*exp(-3*t)','y(0)=1','Dy(0)=2','D2y(0)=1','t')
clf
ezplot(y1,[0,2]);	
title('Solution to D3y+8*D2y+37*Dy+50*y = 4*exp(-3*t)')
ylabel('y(t)')
zoom

%y1 =
 
%-256/1105*exp(-3*t)*cos(t)^8+2048/1105*exp(-3*t)*cos(t)^7*sin(t)
%+512/1105*exp(-3*t)*cos(t)^6-3072/1105*exp(-3*t)*cos(t)^5*sin(t)
%-64/221*exp(-3*t)*cos(t)^4+256/221*exp(-3*t)*sin(t)*cos(t)^3
%+64/1105*exp(-3*t)*cos(t)^2-128/1105*exp(-3*t)*sin(t)*cos(t)
%-262/1105*exp(-3*t)+2/1105*exp(-3*t)*cos(8*t)
%-16/1105*exp(-3*t)*sin(8*t)-2/17*exp(-3*t)*cos(t)^4*cos(4*t)
%+2/17*exp(-3*t)*cos(t)^2*cos(4*t)-8/17*exp(-3*t)*cos(t)^3*cos(4*t)*sin(t)
%+4/17*exp(-3*t)*cos(t)*cos(4*t)*sin(t)-2/17*exp(-3*t)*cos(t)^3*sin(4*t)*sin(t)
%+1/17*exp(-3*t)*cos(t)*sin(4*t)*sin(t)+8/17*exp(-3*t)*cos(t)^4*sin(4*t)
%-8/17*exp(-3*t)*cos(t)^2*sin(4*t)+42/17*exp(-2*t)-21/17*exp(-3*t)*cos(4*t)
%+47/68*exp(-3*t)*sin(4*t)

%After simple
%ans =
%42/17*exp(-2*t)
%-1/4*exp(-3*t)-83/68*exp(-3*t)*cos(4*t)+43/68*exp(-3*t)*sin(4*t)
