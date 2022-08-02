%The function Rician returns a correlated rician random variates by Inverse Discrete
%Fourier Transform.  It's simply a Rayleigh with a LOS component.
%Inputs : fm   - the maximum Doppler frequency normalized by the sampling rate.
%         N    - the number of samples.
%         std  - standard deviation for the two zero mean Gaussian variates.
%         Kdb  - K factor in dB.
%Outputs : Zn  - Baseband rician fading sequence.
%          var_r - variance of the rician fading sequence.


function [Zn, var_r] = Rician(fm, N, std, Kdb)
k = 10^(0.1*Kdb);

A = std*randn(1, N);
B = std*randn(1, N);

km = floor(fm*N);

Fk(1) = 0;
for i = 2:km
  Fk(i) = sqrt(1/(2*sqrt(1-((i-1)/(N*fm))^2)));
end

Fk(km+1) = sqrt(km/2*(pi/2-atan((km-1)/sqrt(2*km-1))));
for i = km+2:N-km
  Fk(i) = 0;
end

Fk(N-km+1) = sqrt(km/2*(pi/2-atan((km-1)/sqrt(2*km-1))));
for i = N-km+2:N
  Fk(i) = sqrt(1/(2*sqrt(1-((N-(i-1))/(N*fm))^2)));
end
temp = 0;
for m = 1:N
   Z(m) = A(m).*Fk(m) - j*B(m).*Fk(m);
   temp = temp + (Fk(m)/N)^2;
end
var_r = 1/2;
alpha = sqrt(k*2*var_r);

Zn = ifft(Z)/std/sqrt(2*temp) + alpha;
return;
