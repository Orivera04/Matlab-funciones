%CYCDEMO.M
%
%To demonstrate the use of the routine CYCPLOT.M, which plots a
%three dimensional representation of the cyclic definition
%of an array.
%
%                   Andrew Knight, June 1991
%
a = 50;
e = 10;
N = 64;
Nones =  10 ;
y = 5*[1 ones(1,Nones)  zeros(1,N - 2*Nones - 1) ones(1,Nones)];
s = real(fft(y));
s = max(y)*s/max(s);
clg  
hold off
subplot(211)
cycplot(y,a,e)
title('CYCDEMO.M: Original function')
subplot(212)
cycplot(s,a,e)
hold on
plot([-0.6478 -0.82],[-0.7209 -1.1],'w-')
text(-1.0,-1.3,'d.c. term')
title('Fourier transform')
plot([0.6387 0.4811],[0.7147 0.3957],'w-')
text(0.39,0.14,'Nyquist frequency')
