function Y = env(y)

%function Y = env(y)
%
%Returns the envelope, Y, of a signal, y.  It is recommended that y be detrended 
%before its envelope is calculated (go yenv = env(detrend(y)) ).
%
%					A. Knight, June 1992
%
Y = fft(y);
N = length(Y);
indpos = 1:N/2;
indneg = (N/2 + 1):N;
Y(indneg) = 2*Y(indneg);
Y(indpos) = zeros(indpos);
Y = ifft(Y);
Y = abs(Y);
