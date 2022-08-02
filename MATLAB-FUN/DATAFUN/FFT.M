%FFT	Discrete Fourier transform.
%	FFT(X) is the discrete Fourier transform of vector X.  If the
% 	length of X is a power of two, a fast radix-2 fast-Fourier
% 	transform algorithm is used.  If the length of X is not a
% 	power of two, a slower non-power-of-two algorithm is employed.
% 	FFT(X,N) is the N-point FFT, padded with zeros if X has less
% 	than N points and truncated if it has more.
% 	If X is a matrix, the FFT operation is applied to each column.
%
% 	See also IFFT, FFT2, IFFT2, FFTSHIFT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
