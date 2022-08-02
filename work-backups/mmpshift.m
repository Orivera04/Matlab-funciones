function s=mmpshift(a,b)
%MMPSHIFT Shift Polynomial, A(x) -> A(x+b). (MM)
% MMPSHIFT(A,b) shifts the polynomial A(x) by b giving A(x+b).
%
% See also MMPADD, MMPSIM, MMPSCALE, MMPOLY, MMP2STR, POLY, CONV.

% Calls: mmpadd

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/16/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

n=length(a);
if n==1, s=a; return, end
p=[1 b];
s=a(1)*p;
for i=2:n-1  % use Horner's Rule
	s=conv(mmpadd(s,a(i)),p);
end
s=mmpadd(s,a(n));
