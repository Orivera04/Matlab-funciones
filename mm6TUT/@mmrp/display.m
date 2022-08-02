function display(r)
%DISPLAY Command Window Display of Rational Polynomial Objects. (MM)

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/27/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

loose=strcmp(get(0,'FormatSpacing'),'loose');
if loose, disp(' '), end
var=inputname(1);
if isempty(var)
	disp('ans =')
else
	disp([var ' ='])
end
nstr=mmp2str(r.n,r.v);
nlen=length(nstr);
if length(r.d)>1
	dstr=mmp2str(r.d,r.v);
else
	dstr=[];
end
dlen=length(dstr);
dash='-';
if loose, disp(' '), end
if dlen % denominator exists
	m=max(nlen,dlen);
	disp('MMRP Rational Polynomial Object:')
	disp([blanks(ceil((m-nlen)/2)) nstr]);
	disp(dash(ones(1,m)));
	disp([blanks(fix((m-dlen)/2)) dstr]);
else
	disp('MMRP Rational Polynomial Object:')
	disp(nstr);
end
if loose, disp(' '), end
