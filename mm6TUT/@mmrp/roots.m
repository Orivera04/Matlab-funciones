function [z,p]=roots(r)
%ROOTS Find Roots of Rational Polynomial Objects. (MM)
% ROOTS(R) returns the roots of the numerator of R.
% [Z,P]=ROOTS(R) returns the zeros and poles of R in
% Z and P respectively.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/27/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9


z=roots(r.n);
if nargout==2
	p=roots(r.d);
end
