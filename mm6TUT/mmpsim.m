function y=mmpsim(x,tol)
%MMPSIM Polynomial Simplification, Strip Leading Zero Terms. (MM)
% MMPSIM(P) Deletes leading zeros and small coefficients in the
% polynomial P(s). Coefficients are considered small if their
% magnitude is less than both one and max(abs(P))*100*eps.
% MMPSIM(P,TOL) uses TOL for its smallness tolerance.
%
% See also MMPADD, MMPPOLY, MMPSCALE, MMPSHIFT, MMP2STR, POLY, CONV.  

% D.C. Hanselman, University of Maine, Orono ME,  04469
% 3/4/95, v5: 1/14/97, 3/22/97, 7/22/00
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<1 | ~isnumeric(x)
   error('First Input Must be Numeric')
end
x=x(:).';						     % make sure input is a row
if nargin<2
	tol=max(abs(x))*100*eps;    % default tolerance
else
   tol=max(tol(1),eps);         % check user tolerance 
end
i=find(abs(x)<.99 & abs(x)<tol);% find insignificant indices
x(i)=0;							     % set them to zero
i=find(x~=0);					     % find significant indices
if isempty(i) 
	y=0;						        % the extreme case: nothing left!
else
	y=x(i(1):end);		           % start with first significant term
end
