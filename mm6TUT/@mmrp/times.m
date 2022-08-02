function r=times(a,b)
%TIMES Dot Times for Rational Polynomial Objects. (MM)

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/27/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

a=mmrp(a); % convert inputs to mmrp if mecessary
b=mmrp(b);
rn=conv(a.n,b.n);
rd=conv(a.d,b.d);
if ~strcmp(a.v,b.v)
	warning('Variables Not Identical')
end
rv=a.v;
r=mmrp(rn,rd,rv);
