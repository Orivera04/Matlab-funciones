function z=poles(r)
%POLES Poles of a Rational Polynomial Object. (MM)

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/27/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ~isa(r,'mmrp')
	error('POLES Defined for MMRP Objects Only.')
end
z=roots(r.d);
