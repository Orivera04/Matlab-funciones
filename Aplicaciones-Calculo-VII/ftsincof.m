function c=ftsincof(y,period)
%
% c=ftsincof(y,period)
% ~~~~~~~~~~~~~~~~~~~
% This function computes 500 Fourier sine
% coefficients for a piecewise linear 
% function defined by a data array 
% y      - an array defining the function
%          over half a period as
%          Y(x)=interp1(y(:,1),y(:,2),x)
% period - the period of the function
% 
xft=linspace(0,period/2,513);
uft=interp1(y(:,1),y(:,2)/512,xft);
c=fft([uft,-uft(512:-1:2)]); 
c=-imag(c(2:501)); 