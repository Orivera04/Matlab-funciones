function x = ifft2(f, mrows, ncols)
%IFFT2	Two-dimensional inverse discrete Fourier transform.
%	IFFT2(F) returns the two-dimensional inverse Fourier transform
%	of matrix F.  If F is a vector, the result will have the same
%	orientation.
%	IFFT2(F,MROWS,NCOLS) pads matrix F with zeros to size MROWS-by-NCOLS
%	before transforming.
%
%	See also FFT2, FFTSHIFT.

%	J.N. Little 12-18-85
%	Revised 4-15-87 JNL
%	Revised 5-3-90 CRD
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[m, n] = size(f);
% Basic algorithm.
if (nargin == 1) & (m > 1) & (n > 1)
    x = conj(fft(fft(conj(f)).')).';
    x = x/prod(size(x));
    return;
end

% Padding for vector input.

if nargin < 3, ncols = n; end
if nargin < 2, mrows = m; end
mpad = mrows; npad = ncols;
if m == 1 & mpad > m, f(2, 1) = 0; m = 2; end
if n == 1 & npad > n, f(1, 2) = 0; n = 2; end
if m == 1, mpad = npad; npad = 1; end   % For row vector.

% Transform.

x = ifft(f, mpad);
if m > 1 & n > 1, x = ifft(x.', npad).'; end
