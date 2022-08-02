% P6_24.M  Plot Bessel Function (Fraunhofer)
%  (2*J1(pi*x)/pi*x)^2  (Even Function)
xplus=[.01:.01:4];
% Reverse columns of xplus. nth column of xplus= 1st column of xneq
n=length(xplus)
xneg=-xplus(1,n:-1:1);
x=[xneg 0 xplus];
arg=xplus*pi;
f=2*bessel(1,arg);
F=(f./arg).^(2);
F1=F(1,n:-1:1);
Fran=[F1 1 F];
clf
plot(x,Fran)
title('Fraunhofer Diffraction Pattern')
xlabel('x')
ylabel('Intensity')
zoom
% 
% Add a few comments to explain the script
%