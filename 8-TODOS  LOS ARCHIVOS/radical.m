function y = radical(x,n)
%RADICAL Real specified roots of real array.
%
%   Y = RADICAL(X, N) returns the real roots of polynomials Y.^N - X .
%   Elements of N that correspond to negative elements of X must be odd 
%   integers.
%   X and N  must have the same dimensions unless one is a scalar. 
%   A scalar can operate into anything.   
%
%   See also realpow, nthroot
%
% Example:
% >> x = [-1 -64 81; 32 0 49; 0 1 0];  n = [3 3 4; 5 2 2; 0 0 inf];
% >> radical(x,n)
% 
% ans =
% 
%     -1    -4     3
%      2     0     7
%    NaN     1     1
% 
%RADICAL is a replacement for NTHROOT which is famous for bugs.

% Mukhtar Ullah
% November 5, 2004
% mukhtar.ullah@informatik.uni-rostock.de

if ~isreal(x) || ~isreal(n) 
   error('MATLAB:radical:ComplexInput', 'Both X and N must be real.');
end

if any(x(:) < 0 & mod(n(:),2) ~= 1)
   error('MATLAB:radical:NegXNotOddIntegerN',...
         ['Elements of N corresponding to ',...
          'negative elements of X must be odd integers.']);
end

p = nan(size(n)); 
i = n ~= 0;
p(i) = 1./n(i);
y = sign(x).* abs(x).^p;

k = (x==0 & isinf(n)) | (x==1 & n==0);            % Index for Known limits
r = y~=0 & x~=0 & isfinite(y) & isfinite(n);      % Index for Correction
if ~isscalar(x), x = x(r); end

if ~isscalar(n), n = n(r); end

y(r) = y(r) - (y(r).^n - x)./(n.* y(r).^(n-1));   % Newton's Method
y(k) = 1;                                         % Known limits     