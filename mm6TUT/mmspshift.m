function pp=mmspshift(pp,xo)
%MMSPSHIFT Shift Spline Domain. (MM)
% MMSPSHIFT(PP,Xo) returns a piecewise polynomial
% based on the piecewise polynomial PP that shifts
% the breakpoints by Xo. If Xo>0, the breakpoints
% increase by Xo. If Xo<0, the breakpoints decrease by Xo.
%
% See also MMSPHELP

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 03/20/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin~=2 | ~isnumeric(xo) | numel(xo)~=1
   error('Xo Must be a Numeric Scalar.')
end
[br,co,l,k,d]=unmkpp(pp);
pp=mkpp(br+xo,co,d);
