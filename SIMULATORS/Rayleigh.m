%The function rayleigh returns a correlated rayleigh random variates by Inverse Discrete
%Fourier Transform.  
%Inputs : fm   - the maximum Doppler frequency normalized by the sampling rate
%         N    - the number of samples
%         std  - standard deviation for the two zero mean Gaussian variates.
%Outputs : Zn  - Baseband rayleigh fading sequence 
%          var_r - variance of the rayleigh fading sequence.

function [Zn, var_r] = Rayleigh(fm, N, std)

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
for k = 1:N
   Z(k) = A(k).*Fk(k) - j*B(k).*Fk(k);
   temp = temp + (Fk(k)/N)^2;
end
var_r = 1/2;
Zn = ifft(Z)/std/sqrt(2*temp);
return;
