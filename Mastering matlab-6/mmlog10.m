function [m,e]=mmlog10(x)
%MMLOG10 Dissect Decimal Floating Point Numbers. (MM)
% [M,E]=MMLOG10(X) returns the mantissa M and exponent E of X,
% such that X=M.*(10.^(E)). M is in the range 1<= M <10.
% E contains integers.
%
% See also LOG2, LOG10

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 3/28/96, v5: 1/14/97, 8/17/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8

% create output arrays
m=zeros(size(x));
e=m;
% capture exceptions
tmpa=isnan(x);  % NaN's
m(tmpa)=nan;
e(tmpa)=nan;
tmpb=isinf(x);  % +/- infs
m(tmpb)=1;
e(tmpb)=x(tmpb);
tmpc=(x==0);    % 0's
%m(tmpc)=0; e(tmpc)=0; %these values are already zero!
% now for "good" numbers
tmp=~(tmpa|tmpb|tmpc);
e(tmp)=floor(log10(abs(x(tmp))));
e(tmp)=e(tmp)+(abs(x(tmp))>=10.^(e(tmp)+1));
m(tmp)=x(tmp)./10.^e(tmp);