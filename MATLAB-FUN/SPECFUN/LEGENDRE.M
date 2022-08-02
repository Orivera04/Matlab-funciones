function plm = legendre(l, amu)
%LEGENDRE Associated Legendre functions.
%	P = LEGENDRE(N,X) computes the associated Legendre functions 
%	of degree N and order M = 0, 1, ..., N, evaluated at X. 
%	N is an integer less than 257. X is a vector whose elements X(j) 
%	are real and satisfy abs(X(j)) <= 1.
% 
%	The output P is an (N+1)-by-L matrix, where L = length(X).
%	The P(i,j) entry corresponds to the associated Legendre function
%	of degree N and order (i-1) evaluated at X(j). 
%
%	The mathematical definition of P is
% 
%       	P(n,m;x) = (-1)^m * (1-x^2)^(m/2) * (d/dx)^m { P(n,x) },
%                where P(n,x) is the Legendre polynomial of degree n.
%
%	Note that the first row of P is the Legendre polynomial
%	evaluated at X. (the M = 0 case)
% 
%	Example:
%       	legendre(2, 0:0.1:0.2) returns a matrix of the form
% 
%        	P(2,0;0)        P(2,0;0.1)      P(2,0;0.2)
%        	P(2,1;0)        P(2,1;0.1)      P(2,1;0.2)
%        	P(2,2;0)        P(2,2;0.1)      P(2,2;0.2)

%   Acknowledgement:
%
%       This program is based on a Fortran program by Robert L. Parker,
%	Scripps Institution of Oceanography, Institute for Geophysics and 
%	Planetary Physics, UCSD. February 1993.
%
%       MATLAB version: D. L. Chen, 5/24/93.
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%
%   Reference:
%         [1] M. Abramowitz and I.A. Stegun, "Handbook of Mathematical
%               Functions", Dover Publications, 1965, Ch. 8.
%
%   Note on Algorithm:
%
%	LEGENDRE uses a three-term backward recursion relationship in M.
%	This recursion is on the Schmidt semi-normalized Associated 
%	Legendre functions SP(n,m;x), which are related to the standard 
%	Abramowitz & Stegun functions P(n,m;x) by
%
%		SP(n,m;x) = sqrt( (n-m)!/(n+m)! ) * P(n,m;x)
% 
%	These semi-normalized functions are then re-normalized at the end 
%	of the code to return the standard P(n,m;x). 

% Initialize lmx
lmx = 256;

% Check degree constraints
if l > lmx
    error('Degree l too great for LEGENDRE: should be <= 256')
elseif l <= 0 
    plm = ones(size(amu));
    return
end

% Convert amu to a row vector
amu = amu(:)';

% Initialize parameters
nmx=2*lmx;
% The following three are parameters from Parker's Fortran code
tol = 0.100000001686238353e-15;
alogt = -0.368413619995117188e+02;
tstart = 0.999999993922529029e-08;

rootn=sqrt(0:nmx);
s=sqrt(1.0 - amu.^2);
plm = zeros(l+1,length(amu));
tlm = zeros(l+1,length(amu));

% Calculate TWOCOT, separating out the amu = -1,+1 cases first
twocot = amu;		% initialize dimensions of TWOCOT

kk = find(amu == -1);
if ~isempty(kk)
    twocot(kk) = Inf*ones(size(kk));
end;

kk = find(amu == 1);
if ~isempty(kk)
    twocot(kk) = -Inf*ones(size(kk));
end;

kk = find(s~=0);
if ~isempty(kk)
    twocot(kk)  = -2.0*amu(kk)./s(kk);
end;

% Small sine: prevent underflow By starting at m=m1-1<l

% First, replace s_copy = 0 with s_copy = NaN to avoid log(0) error messages.
% This is okay since we want nonzero s anyway.
scopy = s;
kk = find(s == 0);
scopy(kk) = NaN*ones(size(kk));
ind = find(l*log(scopy) < alogt);

if ~isempty(ind)
% Approx solution of x*ln(x)=y 
    v = 9.2-alogt./(l*s(ind));
    w = 1./log(v);
    m1=1+l*s(ind).*v.*w.*(1.0058+ w.*(3.819 - w*12.173));
    m1=min(l+1, floor(m1));

% column-by-column recursion
    for k = 1: length(m1)
        mm1 = m1(k);
        col = ind(k);
        tlm(mm1:l+1,col)= zeros(size(mm1:l+1))';

        % Start recursion with proper sign
        tlm(mm1,col)  = sign(rem(mm1,2)-0.5)*tstart;
        if amu(k) < 0, tlm(mm1,col)=sign(rem(l+1,2)-0.5)*tstart; end;

        % Recur from m1 to m=0, carrying normalizing 
        sumsq=tol;
        for m= mm1-2:-1:0,
	    tlm(m+1,col)=((m+1)*twocot(col)*tlm(m+2,col)- ...
		rootn(l+m+3)*rootn(l-m)* tlm(m+3,col))/ ...
		(rootn(l+m+2)*rootn(l-m+1));
	    sumsq=tlm(m+1,col)^2 + sumsq;
        end;
        scale=1.0/sqrt(2*sumsq - tlm(1,col)^2);
        tlm(1:mm1+1,col)=scale*tlm(1:mm1+1,col);
    end		% FOR loop

end	% small sine IF loop

% Zero out the columns that have been calculated above, saving S
tmps = s(ind);
s(ind) = zeros(size(ind));
nind = find(s);

% Regular recursion from m=l to 0
if ~isempty(nind)

    % Produce normalization constant
    c=1.0;
    twol=2.0*l;
    for x= 2.0: 2: twol
        c=c - c/x;
    end;
    
    tlm(l+1,nind)= sqrt(c)*(-s(nind)).^l;
    tlm(l,nind)  = tlm(l+1,nind).*twocot(nind).*l./sqrt(twol);

    % Recur downwards to m=0
    for m= l-2: -1: 0,
        tlm(m+1,nind)=((m+1)*twocot(nind).*tlm(m+2,nind) ...
			- rootn(l+m+3)*rootn(l-m).* ...
		        tlm(m+3,nind))/(rootn(l+m+2)*rootn(l-m+1));
    end;

end	% IF loop

% Calculate the Schmidt semi-normalized functions
s(ind) = tmps;	% restore s
plm(1:l,:)=tlm(1:l,:);
plm(l+1,:)=tlm(l+1,:);

% Polar argument   (mu=+-1)
s0 = find(s == 0);
if ~isempty(s0)
    plm(1,s0)=amu(s0).^l;
end

% Calculate the standard A&S functions from the Schmidt semi-normalized
% functions by multiplying each row by 1/(Schmidt constant)
for r = 2: l+1
    m = r-1;

    % Find 1/(Schmidt const) for row r
    const = exp(0.5 * (sum(log(2:l+m)) - sum(log(2:l-m)) ) );

    plm(r,:) = const*plm(r,:);

end;
