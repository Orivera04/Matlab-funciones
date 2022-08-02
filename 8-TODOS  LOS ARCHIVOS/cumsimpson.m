function z=cumsimpson(x,y)
%CUMSIMPSON Cumulative Simpson Numerical Integration.
% Z=CUMSIMPSON(Y) computes an approximation of the cumulative integral of Y
% using a Simpson rule with unit spacing between the data points in Y. To
% compute the integral for spacing different from one, multiply Z by the
% spacing increment. When Y is a matrix, the cumulative integral is
% computed over each column of Y.
%
% Z=CUMSIMPSON(X,Y) computes the integral with respect to the data in
% vector X. X need NOT be EQUALLY spaced but must have the same number of
% elements as Y. When Y is a matrix, Y must have as many rows as X has
% elements.
% 
% Z has the same dimensions as Y.
%
% Algorithm: To support non equally spaced X and MATLAB vectorization, a
% modified Simpson rule is applied. A second order polynomial is fit to
% each sequence of three consecutive data points, e.g., X(i-1), X(i), and
% X(i+1) for i=2:length(X)-1. The area under this polynomial is then
% computed from X(i-1) to X(i) and from X(i) to X(i+1). Because there are
% two polynomials computed over each segment of X (except the first X(1) to
% X(2) and the last X(end-1) to X(end)), the area under the two polynomials
% for each segment are averaged. As a result, this algorithm is more
% accurate than the standard Simpson's rule. Can someone do an error
% analysis for the equally spaced data case?
%
% See also CUMSUM, CUMTRAPZ, QUAD, QUADV.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% MasteringMatlab@yahoo.com
% Mastering MATLAB 7
% 2005-09-30

if nargin<2
   y=x;
   [ry,cy]=size(y);
   if ry==1
      x=1:cy;
   else
      x=1:ry;
   end
elseif nargin==2
   [ry,cy]=size(y);
else
   error('One or Two Inputs Are Required.')
end
if ndims(y)~=2
   error('N-dimensional Data is Not Supported.')
end
if min(size(x))>1
   error('X Must be a Vector.')
end
x=x(:);   % make x a column
if ry==1 % y is a row vector, make it a column
   yisrow=true;
   y=y.';
   ry=cy;
   cy=1;
else
   yisrow=false;
end
if length(x)~=ry
   error('Length of X Must Match Length of Y or Rows of Matrix Y.')
end
if length(x)<3
   error('At Least 3 Data Points are Required.')
end
dx=repmat(diff(x),1,cy);
dy=diff(y);

dx1=dx(1:end-1,:);
dx2=dx(2:end,:);
dxs=dx1+dx2;
dy1=dy(1:end-1,:);
dy2=dy(2:end,:);

a=(dy2./(dx2.*dxs) - dy1./(dx1.*dxs))/3;
b=(dy2.*dx1./(dx2.*dxs) + dy1.*dx2./(dx1.*dxs))/2;
c=y(2:end-1,:);

i1=((a.*dx1-b).*dx1+c).*dx1; % left half integral
i2=((a.*dx2+b).*dx2+c).*dx2; % right half integral

z=[zeros(1,cy);...
   cumsum([i1(1,:); (i1(2:end,:)+i2(1:end-1,:))/2; i2(end,:)])];

if yisrow
   z=z.';
end