function r=rdivide(a,b)
%RDIVIDE Right Dot Division for Rational Polynomial Objects. (MM)

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/27/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

a=mmrp(a); % convert inputs to mmrp if necessary
b=mmrp(b);
rn=conv(a.n,b.d);
rd=conv(a.d,b.n);
if ~strcmp(a.v,b.v)
	warning('Variables Not Identical')
end
rv=a.v;
r=mmrp(rn,rd,rv);
