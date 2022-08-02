function [n,d,v]=char(r)
%CHAR Extract String From Rational Polynomial Object. (MM)
% CHAR(R) returns a 3 row string array containing R in the
% format used by DISPLAY.M
% [N,D]=CHAR(R) extracts the numerator N and denominator D 
% as character strings from the rational polynomial object R.
% [N,D,V]=CHAR(R) in addition returns the variable V.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/30/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargout<=1
   nstr=mmp2str(r.n,r.v);
   nlen=length(nstr);
   if length(r.d)>1
      dash='-';
      dstr=mmp2str(r.d,r.v);
      dlen=length(dstr);
      m=max(nlen,dlen);
      n=char([blanks(ceil((m-nlen)/2)) nstr],...
         dash(ones(1,m)),...
         [blanks(fix((m-dlen)/2)) dstr]);
   else
      n=nstr;
   end
elseif nargout>1
   n=mmp2str(r.n);
   d=mmp2str(r.d);
end
if nargout>2
   v=r.v;
end
