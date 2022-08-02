function f = fft2(x, mrows, ncols)
%FFT2	Two-dimensional Fast Fourier Transform.
%	FFT2(X) returns the two-dimensional Fourier transform of matrix X.
%	If X is a vector, the result will have the same orientation.
%	FFT2(X,MROWS,NCOLS) pads matrix X with zeros to size MROWS-by-NCOLS
%	before transforming.
%
%	See also IFFT2, FFT, IFFT, FFTSHIFT.

%	J.N. Little 12-18-85
%	Revised 4-15-87 JNL
%	Revised 5-3-90 CRD
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[m, n] = size(x);
% Basic algorithm.
if (nargin == 1) & (m > 1) & (n > 1)
    f = fft(fft(x).').';
    return;
end

% Padding for vector input.

if nargin < 3, ncols = n; end
if nargin < 2, mrows = m; end
mpad = mrows; npad = ncols;
if m == 1 & mpad > m, x(2, 1) = 0; m = 2; end
if n == 1 & npad > n, x(1, 2) = 0; n = 2; end
if m == 1, mpad = npad; npad = 1; end   % For row vector.

% Transform.

f = fft(x, mpad);
if m > 1 & n > 1, f = fft(f.', npad).'; end
