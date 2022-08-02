function r=power(a,b)
%POWER Dot Power for Rational Polynomial Objects. (MM)

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/27/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ~isnumeric(b)
	error('Operation Not Defined for MMRP Objects.')
end
if length(b)~=1 | fix(b)~=b
	error('Power Must be an Integer.')
end
if b<0
	a=1./a;
end
r=a;
for i=2:abs(b)
	r=r*a;
end
