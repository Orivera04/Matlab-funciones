function s=int(r)
%INT Integration of a Polynomial Object. (MM)
% INT(R) returns a polynomial object that is the integral of the
% the polynomial object R.
% R cannot contain a denominator.
% To include the constant of integration, simply add it:
% INT(R) + Ro

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/30/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if length(r.d)~=1
	error('R Must Not Contain a Denominator.')
end
n=[r.n./(length(r.n):-1:1) 0];
s=mmp(n,r.d,r.v);
