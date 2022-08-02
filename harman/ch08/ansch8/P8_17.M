% P8_17.M Fourier series of Square wave 
%
% Plot the Fourier series of the function f(t) 
%   f(t)=1     0 < t < pi
%   f(t)=-1   -pi < t <  0
%
clear
T=2*pi		% Period
w0 = 2*pi/T	% Radian frequency
A=1		% Amplitude
K=(4*A)/pi;
% Plot 5 terms of the series
t = -pi:.031:pi;	% Time points for plotting
sizet=size(t);
fn =(zeros(sizet));	% Fourier approximation at each t
yplt=zeros(sizet);		% For plot of f(t)
% 5 terms
for n=1:5
  fn= fn + K*(sin((2*n-1)*w0*t)/(2*n-1)); 
end					
%
for k=1:length(t)
  if t(k) < 0 
   yplt(k)=-1;
  else
   yplt(k)=1;
  end 
end
clf
subplot(2,1,1),plot(t,fn,t,yplt,'--');
xlabel('t')
ylabel('f(t)')
title('Fourier Series Approximation to Square Wave')
legend(['N=',num2str(n)],'f(t)')
% Add 5 more terms
for n=6:10
  fn= fn + K*(sin((2*n-1)*w0*t)/(2*n-1)); 
end					
subplot(2,1,2),plot(t,fn,t,yplt,'--');
xlabel('t')
ylabel('f(t)')
legend(['N=',num2str(n)],'f(t)')
%
% Modify the script to allow an arbitrary number
%  of components
