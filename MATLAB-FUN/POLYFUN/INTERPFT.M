function y = interpft(x,ny);
%INTERPFT 1-D interpolation using a FFT method.
%	Y = INTERPFT(X,N) returns a vector Y of length N obtained
%	by interpolation in the Fourier transform of X. 
%	Assume x(t) is a periodic function of t with period p, sampled
%	at equally spaced points, X(i) = x(T(i)) where T(i) = (i-1)*p/M,
%	i = 1:M, M = length(X).  Then y(t) is another periodic function
%	with the same period and Y(j) = y(T(j)) where T(j) = (j-1)*p/N,
%	j = 1:N, N = length(Y).  If N is an integer multiple of M,
%	then Y(1:N/M:N) = X.
%
%	If X is a matrix, interpolation is done on each column. 
%
%	INTERPFT, with no input arguments, demonstrates itself.
%
%	See also INTERP1, INTERP2, GRIDDATA.

%	Charles R. Denham, MathWorks, 1988.
%	Robert Piche, Tampere University of Technology, 10/93.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 1      % Demonstration.
   nx = 5;
   x= rand(nx,1);
   ny = 40;
end

[m,n] = size(x);
row = (m == 1);
if row
   x = x.';
   [m,n] = size(x);
end
%  If necessary, increase ny by an integer multiple to make ny > m.
if ny > m
   incr = 1;
else
   if ny==0, y=[]; return, end
   incr = floor(m/ny) + 1;
   ny = incr*ny;
end
a = fft(x);
nyqst = ceil((m+1)/2);
b = [a(1:nyqst,:) ; zeros(ny-m,n) ; a(nyqst+1:m,:)];
if rem(m,2) == 0
   b(nyqst,:) = b(nyqst,:)/2;
   b(nyqst+ny-m,:) = b(nyqst,:);
end
y = ifft(b);
if ~any(any(imag(x))), y = real(y); end
y = y * ny / m;
y = y(1:incr:ny,:);  % Skip over extra points when oldny <= m.
if row, y = y.'; end

if nargin < 1      % Demonstration.
   ax = (0:(nx-1)) ./ nx; ax = nx .* ax + 1;
   ay = (0:(ny-1)) ./ ny; ay = nx .* ay + 1;
   plot(ax, x, 'wo', ay, y, 'cx', ay, y, 'c-')
   title('Demonstration of INTERPFT')
   xlabel('x'), ylabel('y')
end
