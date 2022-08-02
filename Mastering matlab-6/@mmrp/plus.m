function r=plus(a,b)
%PLUS Addition for Rational Polynomial Objects. (MM)

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/27/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if isnumeric(a)
	rn=mmpadd(a*b.d,b.n);
	rd=b.d;
	rv=b.v;
elseif isnumeric(b)
	rn=mmpadd(b*a.d,a.n);
	rd=a.d;
	rv=a.v;
else % both polynomial objects
	if ~isequal(a.d,b.d)
		rn=mmpadd(conv(a.n,b.d),conv(b.n,a.d));
		rd=conv(a.d,b.d);
	else
		rn=mmpadd(a.n,b.n);
		rd=b.d;
	end
	if ~strcmp(a.v,b.v)
		warning('Variables Not Identical')
	end
	rv=a.v;
end
r=mmrp(rn,rd,rv);
