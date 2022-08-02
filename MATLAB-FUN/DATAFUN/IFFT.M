function y = ifft(x,nfft)
%IFFT	Inverse discrete Fourier transform.
%	IFFT(X) is the inverse discrete Fourier transform of vector X.
%	IFFT(X,N) is the N-point inverse transform.
%
%	See also FFT, FFT2, IFFT2, FFTSHIFT.

%	J.N. Little 4-21-85
%	Revised 6-11-88 JNL
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin == 2
    y = conj(fft(conj(x),nfft));
else
    y = conj(fft(conj(x)));
end
[m,n] = size(y);
if m == 1
    m = n;
end
y = y/m;

