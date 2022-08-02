function [s,w]=mmpscale(a,b)
%MMPSCALE Scale Polynomial, A(x) -> A(x/b). (MM)
% MMPSCALE(A,b) scales the polynomial A(x) by b giving A(x/b).
% The roots of A(x/b) are the product of b and the roots of A(x).
%
% [S,b]=MMPSCALE(A) scales the polynomial A(x) so that all its
% roots reside in the unit circle. b is returned such that
% MMPSCALE(S,b) returns the original A(x).
%
% See also MMPADD, MMPSIM, MMPOLY, MMPSHIFT, MMP2STR, POLY, CONV.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/18/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1 & nargout~=2,
   error('Incorrect Function Arguments.')
end

if nargin==1  % scale to place roots in unit circle
   b=max(abs(roots(a)));
   if b<=1, b=1;  % roots are there already, no work
   else,    b=1/b;
   end
end
s=a./(b.^(length(a)-1:-1:0));
if nargout==2, w=1/b; end
