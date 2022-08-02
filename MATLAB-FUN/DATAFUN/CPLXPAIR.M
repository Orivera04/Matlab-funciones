function z = cplxpair(x,tol)
%CPLXPAIR Sort numbers into complex conjugate pairs.
%	Y = CPLXPAIR(X) rearranges the elements of vector X so that
%	complex numbers are collected into matched pairs of complex
%	conjugates.  The pairs are ordered by increasing real part.
%	Any purely real elements are placed after all the complex pairs.
%	Y = CPLXPAIR(X,TOL) uses a relative tolerance of TOL for
%	comparison purposes.  The default is TOL = 100*EPS.

%	L. Shure 1-27-88
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 2
    tol = 100*eps;    % need to give a tolerance more generous than eps
end
if isempty(x)
	z = x;
	return;
end
r = [];
j = sqrt(-1);
[m,n] = size(x);
z  = zeros(m,n); % return number in same shape vector as input
x = x(:);     % make sure x is a column vector
nz = max(size(z));

% first segregate reals
ir = find(abs(imag(x)) <= tol*abs(x));
nr = max(size(ir));
if ~isempty(ir)
    r  = sort(real(x(ir)));    % return sorted reals first
    x(ir) = [];    % remove these values from input array
end
clear ir

nc = max(size(x));
if nc == 0    % no complex numbers
    z = r;
    return
end
if rem(nc,2)
    error('Complex numbers can''t be paired');
end

% copy complex x to a work vector c
c = x;
np = nc/2;    % number of pairs supposedly

% get values to upper half plane
c = real(c) + j*abs(imag(c));

% ordered by real part (since sort is very sensitive to magnitudes)
[cc,cind] = sort(real(c));
c = cc +j*imag(c(cind));
% check to see if real parts are at least in pair
if any(abs(cc(1:2:nc)-cc(2:2:nc)) > tol*abs(c(1:2:nc)))
    error('Complex numbers can''t be paired')
end
x = x(cind);    % reorder x the same way c has been
clear cc

% check real part pairs to see if imag parts are paired by conjugates
% be careful with multiple roots!
ip = 1;    % initialize pair counter
while (ip <= np)
% find indices for same real parts - but be careful because a real part can be 0
    ii = find(abs(real(c(1:2:nc))-real(c(2*ip))) <= tol*abs(c(2*ip)));
    if isempty(ii)
        error('Complex numbers can''t be paired')
    end
    if max(size(ii)) > 1
% multiple pairs with same real part - sort on imag(c(ii)) for all with real part
% ij below are indices with same real part
        ij = find(abs(real(c(1:nc)) - real(c(2*ip))) <= tol*abs(c(2*ip)));
        nn = max(size(ij));
        xtemp = x(ij);
        [xi, xind] = sort(imag(xtemp));    % sort on imag parts - should be paired
        xtemp = xtemp(xind);
% check pairing
        if any((abs(xtemp-conj(xtemp(nn:-1:1))) > tol*abs(xtemp)))
            error('Complex numbers can''t be paired')
        else
            x(ij(1):2:ij(nn-1)) = xtemp(1:nn/2);
            x(ij(2):2:ij(nn)) = conj(xtemp(1:nn/2));
        end
    else    % only one pair with that real part
        if abs(x(2*ip)-conj(x(2*ip-1))) > tol*abs(x(2*ip))
            error('Complex numbers can''t be paired')
        else
            xtmp = real(x(2*ip))-sqrt(-1)*abs(imag(x(2*ip)));
            x(2*ip-1:2*ip) = [xtmp conj(xtmp)];
        end
    end
    ip = ip + max(size(ii));    % increment pair counter
end
% copy complex pairs into return vector
z(1:nc) = x(1:nc);
% append reals to this
z(nc+1:nc+nr) = r;
