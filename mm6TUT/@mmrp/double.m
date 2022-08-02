function [n,d]=double(r)
%DOUBLE Extract Numerical Data From Rational Polynomial Object. (MM)
% DOUBLE(R) returns a matrix with the numerator of R in
% the first row and the denominator in the second row.
% [N,D]=DOUBLE(R) extracts the numerator N and denominator D
% from the rational polynomial object R.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/30/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargout<=1 & length(r.d)>1
   nlen=length(r.n);
   dlen=length(r.d);
   n=zeros(1,max(nlen,dlen));
   n=[mmpadd(n,r.n);mmpadd(n,r.d)];
elseif nargout<=1
	n=r.n;
else % nargout==2
	n=r.n;
	d=r.d;
end
