function [n,d]=size(r,x)
%SIZE Size for Rational Polynomial Objects. (MM)
% SIZE(R) returns [n;d] where n and d are the respective orders
% of the numerator and denominator of R.
% SIZE(R,1) returns the numerator order.
% SIZE(R,2) returns the denominator order.
% [n,d]=SIZE(R) returns the numerator and denominator orders in
% n and d respectively.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/27/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

no=length(r.n)-1;
do=length(r.d)-1;
if nargin==1
	if nargout<=1
		n=[no;do];
	else
		n=no; d=do;
	end
elseif nargin==2
	if x==1
		n=no;
	elseif x==2
		n=do;
	else
		error('Second Argument Must be 1 or 2.')
	end
end
