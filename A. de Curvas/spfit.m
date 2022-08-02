function output = spfit(x,y,xb,ord)
%SPFIT Fit a spline to noisy data.
%   PP = SPFIT(X,Y,XB) fits a piecewise cubic spline with break
%   points XB to the noisy data (X,Y). Use PPVAL to evaluate PP.
%
%   Example:
%       x = 2*pi*(0:100)/100;
%       y = sin(x) + 0.1*randn(size(x));
%       xb = 0:6;
%       pp = spfit(x,y,xb);
%       z = ppval(pp,x);
%       plot(x,y,'.',x,z);
%
%   PP = SPFIT(X,Y,XB,N) is a generalization to piecewise polynomial 
%   functions of order N (degree N-1), with continuous derivatives
%   up to order N-2. Default is a cubic spline with N = 4.
%
%       N	Function
%       -----------------
%       1	Step function
%       2   Piecewise linear and continuous
%       3   Piecewise quadratic with continuous first derivative
%       4   Piecewice cubic with continuous second derivative (default)
%       5   Etc.

%   Author: jonas.lundgren@saabgroup.com, 2007.

if nargin < 1, help spfit, return, end
if nargin < 2, y = 1; end
if nargin < 3, xb = 0; end
if nargin < 4, ord = 4; end

%   Check data vectors

x = x(:);
y = y(:);
m = length(x);
if length(y) ~= m
    if length(y) == 1
        y = y*ones(size(x));
    else
        error('Data vectors x and y must have the same length!')
    end
end

%   Sort and check the break points

xb = sort(xb(:));
xb = xb([diff(xb)>0; true]);
n = length(xb) - 1;

if n < 1
    n = 1;
    xb = [min(x); max(x)];
    if xb(1) == xb(2)
        xb(2) = xb(1) + 1;
    end
end

%   Adjust limits

xlim = xb;
xlim(1) = -Inf;
xlim(end) = Inf;

%   Generate power- and coefficient-matrices for smoothness conditions

as = [ones(1,ord); ones(ord-1,1)*(ord-1:-1:0)-(0:ord-2)'*ones(1,ord)];
as = max(as,0);
cs = cumprod(as(1:ord-1,:));
ps = as(2:ord,:);
B0 = cs.*0.^ps;

%   Smoothness conditions

B = zeros((ord-1)*(n-1),ord*n);
h = diff(xb);
for k = 1:n-1
    Bk = cs.*h(k).^ps;
    B((ord-1)*(k-1)+1:(ord-1)*k, ord*(k-1)+1:ord*(k+1)) = [Bk, -B0];
end

%   QR-factorization

nn = min(size(B));
[Q,R] = qr(B');
Q2 = Q(:,nn+1:end);

%   Weak conditions (least square sense)

A = zeros(m,n+ord-1);
a = zeros(m,1);
mm = 0;
for k = 1:n
    I = (x <= xlim(k+1)) & (x > xlim(k));
    xdata = x(I) - xb(k);
    ydata = y(I);
    d = length(xdata);
    Ak = (xdata*ones(1,ord)).^(ones(d,1)*(ord-1:-1:0));
    A(mm+1:mm+d,:) = Ak*Q2(ord*(k-1)+1:ord*k,:);
    a(mm+1:mm+d) = ydata;
    mm = mm + d;
end

%   Solve

c = Q2*(A\a);

%   Make piecewise polynomial

coefs = reshape(c,ord,n).';
output = mkpp(xb,coefs);

return

