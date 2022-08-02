% P13_13.M  Vibrating circular membrane
%  Strike a key between plots
% Example plots with J0 (n=0,m=3)
clear
clf
x=[-1:.1:1];
y=x;
[X,Y]=meshgrid(x,y);
r=sqrt(X.^2+Y.^2)/sqrt(2);  % Normalize to 1
% Roots of J0 are 2.40483, 5.52008, 8.65373, 11.7915, ..
lr=8.65373*r;    % m=3
t=0
J=besselj(0,lr)*cos(8.65373*t);
figure(1)
mesh(X,Y,J);
title('Plot at t=0')
pause
figure(2)
t=0.2
J=besselj(0,lr)*cos(8.65373*t);
mesh(X,Y,J);
title('Plot at t=0.2')
pause
figure(3)
t=0.4
J=besselj(0,lr)*cos(8.65373*t);
mesh(X,Y,J);
title('Plot at t=0.4')


