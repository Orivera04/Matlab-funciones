function disp(r)
%DISP Display of Rational Polynomial Objects in Factored Form. (MM)

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/30/98, 2/25/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

loose=strcmp(get(0,'FormatSpacing'),'loose');

[z,p]=roots(r);
z=cplxpair(z);
p=cplxpair(p);

zlen=length(z);
plen=length(p);

v=r.v;
if abs(r.n(1)-1)>1e-6
   zstr=sprintf('%.3g',r.n(1));
elseif abs(r.n(1)+1)>1e-6
   zstr='-';
else
   zstr='';
end
pstr='';
i=1;
while i<=zlen
	if ~isreal(z(i))
		zstr=[zstr '(' mmp2str([1 -2*real(z(i)) abs(z(i))^2],v) ')'];
		i=i+2;
	else
		zstr=[zstr '(' mmp2str([1 -z(i)],v) ')'];
		i=i+1;
	end
end
i=1;
while i<=plen
	if ~isreal(p(i))
		pstr=[pstr '(' mmp2str([1 -2*real(p(i)) abs(p(i))^2],v) ')'];
		i=i+2;
	else
		pstr=[pstr '(' mmp2str([1 -p(i)],v) ')'];
		i=i+1;
	end
end
zlen=length(zstr);
plen=length(pstr);
dash='-';
if plen % denominator exists
	m=max(zlen,plen);
	disp([blanks(ceil((m-zlen)/2)) zstr]);
	disp(dash(ones(1,m)));
	disp([blanks(fix((m-plen)/2)) pstr]);
else
	disp(zstr);
end
if loose, disp(' '), end
		
