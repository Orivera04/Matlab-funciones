function x=mmpintrp(p,y)
%MMPINTRP Inverse Interpolate Polynomial. (MM)
% MMPINTRP(P,y) finds all real values of X where the polynomial y=P(x) has
% the scalar value y. If no values are found, an empty matrix is returned.
%
% See also MMPADD, MMPSIM

% calls: mmpsim

% D.C. Hanselman, University of Maine, Orono, ME 04469
% v5: 3/22/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

sizp=size(p);
if ndims(p)>2 | min(sizp)>1 | max(sizp)==1
	error('P Must be a Vector.')
end
if length(y)~=1
	error('y Must be a Scalar.')
end
p=mmpsim(p);
p(end)=p(end)-y;
if length(p)==2  % easy answer for 1st order polynomial
	x=-p(2)/p(1);
else
	x=roots(p);
	x=x(find(imag(x)==0));
end
