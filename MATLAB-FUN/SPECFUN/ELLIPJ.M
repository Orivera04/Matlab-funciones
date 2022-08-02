function [sn,cn,dn] = ellipj(u,m)
%ELLIPJ	Jacobi elliptic functions SN, CN and DN.
%	[Sn,Cn,Dn] = ELLIPJ(U,M) returns the values of the Jacobi
%	elliptic functions SN, CN and DN, evaluated at argument U
%	and parameter M.  As currently implemented, M is limited
%	to 0 < M < 1.
%	ELLIPJ(U,M) are accurate to EPS.
%	U and M must either be matrices of the same size or either
%	one may be a scalar.
%
%	Be sure you don't confuse the modulus K with the parameter M -
%	they are related in the following way:  M = K^2

%	L. Shure 1-9-88
%	Copyright (c) 1984-94 by The MathWorks, Inc.

%	ELLIPJ uses the method of the arithmetic-geometric mean
%	described in [1].

% References:
%	[1] M. Abramowitz and I.A. Stegun, "Handbook of Mathematical
%        Functions" Dover Publications", 1965, Ch. 16-17.6.

tol = eps(1);
if any(any(imag(u))) | any(any(imag(m)))
	error('Input arguments must be real.')
end
[mm,nm] = size(m);
[mu,nu] = size(u);
if mu ~= mm | nu ~= nm
    if mu*nu == 1 
      u = u*ones(mm,nm);
    elseif mm*nm == 1 
      m = m*ones(mu,nu);
    else
      error('Matrix dimensions must agree.')
    end
end
[ms,ns] = size(u);
mmax = ms*ns;
cn = zeros(ms,ns);
sn = cn;
dn = sn;
m = m(:).';    % make a row vector
u = u(:).';
% pre-allocate space and augment if needed
chunk = 10;
a = zeros(chunk,mmax);
c = a;
b = a;
a(1,:) = ones(1,mmax);
c(1,:) = sqrt(m);
b(1,:) = sqrt(1-m);
n = zeros(1,mmax);
i = 1;
while any(abs(c(i,:)) > tol)
    i = i + 1;
    if i > size(a,1)
      a = [a; zeros(chunk,mmax)];
      b = [b; zeros(chunk,mmax)];
      c = [c; zeros(chunk,mmax)];
    end
    a(i,:) = 0.5 * (a(i-1,:) + b(i-1,:));
    b(i,:) = sqrt(a(i-1,:) .* b(i-1,:));
    c(i,:) = 0.5 * (a(i-1,:) - b(i-1,:));
    in = find((abs(c(i,:)) <= tol) & (abs(c(i-1,:)) > tol));
    if ~isempty(in)
      [mi,ni] = size(in);
      n(in) = ones(mi,ni)*(i-1);
    end
end
phin = zeros(i,mmax);
phin(i,:) = (2 .^ n).*a(i,:).*u;
while i > 1
    i = i - 1;
    in = find(n >= i);
    phin(i,:) = phin(i+1,:);
    if ~isempty(in)
      phin(i,in) = 0.5 * ...
      (asin(c(i+1,in).*sin(rem(phin(i+1,in),2*pi))./a(i+1,in)) + phin(i+1,in));
    end
end
sn(:) = sin(rem(phin(1,:),2*pi));
cn(:) = cos(rem(phin(1,:),2*pi));
dn(:) = sqrt(1 - m .* (sn(:).').^2);
