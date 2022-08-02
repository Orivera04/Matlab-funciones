function z = polyval2d(c,x,y)
% z = POLYVAL2D(V,sx,sy) Two dimensional polynomial evaluation.
%
% If V is a matrix whose elements are the coefficients of a
% polynomial function of 2 variables, then POLYVAL2D(V,sx,sy)
% is the value of the polynomial evaluated at [sx,sy].  Row
% numbers in V correspond to powers of x, while column numbers
% in V correspond to powers of y. If sx and sy are matrices or
% vectors,the polynomial function is evaluated at all points
% in [sx, sy].
%
% If V is one dimensional, POLYVAL2D returns the same result as
% POLYVAL.
%
% Use POLYFIT2D to generate appropriate polynomial matrices from
% f(x,y) data using a least squares method.
 

% Perry W. Stout  June 28, 1995
% 4829 Rockland Way
% Fair Oaks, CA  95628
% (916) 966-0236
% Based on the Matlab function POLYVAL.

%	Polynomial evaluation c(x,y) is implemented using Horner's slick
% method.  Note use of the filter function to speed evaluation when
% the ordered pair [sx,sy] is single valued.

if nargin==2
  y=ones(x); end

if any(size(x) ~= size(y))
error('x and y must have the same dimensions.')
end

[m,n] = size(x);
[rown,coln]= size(c);

if (m+n) == 2
	% Use the built-in filter function when [sx,sy] is single valued 
 % to implement Hoerner's method.

  z= 0;
for i1= 1:coln
	 ccol= c(:,coln+1-i1);
  w = filter(1,[1 -x],ccol);
	 w = w(rown)*(y^(i1-1));
  z= z+w;
end
return
end % Of the scalar computation

% Do general case where X and Y are arrays
z = zeros(m,n);
for i1=1:coln
   ccol= c(:,coln+1-i1);
   w= zeros(m,n);
  for j1=1:rown
  	 w = x.*w + ccol(j1) * ones(m,n);
  end
z= z+w.*(y.^(i1-1));
end
