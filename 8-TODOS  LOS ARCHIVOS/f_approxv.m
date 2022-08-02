function []=f_approxv(f,b,NN)
% f_approxv(f,b,NN)
% Plots the function f and its Fourier series approximation to NN terms.
% This will approximate a function f from zero to b only.  It uses the FFT
% to approximate the Trigonometric Fourier Series coefficients.
% Example:     >>f=inline('sin(x)./x+(cos(x)).^2-exp(x/8)+x.^(x/20)');
%              >>f_approx(f,20,40)  % Approximates the curve nicely.
f = fcnchk(f,'vectorized');  % This allows user easy func use.       
n = 2*NN;
T = b-eps+(b-eps)/(n-2);
x = linspace(eps,T,n+1);   x(end) = [];   fun = f(x);
FUNC = fft(fun);  % Call fft 
FUNC = [conj(FUNC(NN+1)) FUNC(NN+2:end) FUNC(1:NN+1)]/n;
A0 = FUNC(NN+1);   AN = 2*real(FUNC(NN+2:end));
BN = -2*imag(FUNC(NN+2:end));

p = app1(x,A0,AN,BN,T);

xx = linspace(eps,x(end),b*100);   xx(end) = [];   fun = f(xx); 
hand = plot(xx,fun,'r',x,p,'b');   set(hand,'linewidth',2)
grid on;   axis tight;   legend('function','approximation',0) 


function answ=app1(x,A0,AN,BN,T)
ii = 1:length(AN);   lgh = length(x);
[ii x] = meshgrid(ii,x);
AN = repmat(AN,lgh,1);   BN = repmat(BN,lgh,1);
theta = ii.*x.*(2*pi)/T;
answ = (sum(AN.*cos(theta)+BN.*sin(theta),2)+A0)';