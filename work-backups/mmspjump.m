function [ix,idx,iddx]=mmspjump(pp,tol)
%MMSPJUMP Find Spline Discontinuities. (MM)
% [ix,idx,iddx]=MMSPJUMP(PP,TOL) returns vectors identifying
% breakpoint indices where the spline described by the
% piecewise polynomial PP has discontinuities in its values,
% slopes, and curvatures in the variables ix, idx, and iddx
% respectively. TOL=[RelTol AbsTol] gives desired relative
% and absolute tolerances for discontinuity determination.
% If not given TOL=[1e-3 1e-6].
%
% See also MMSPHELP

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 12/2/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<2
   tol=[1e-3 1e-6];
elseif ~isnumeric(tol) | length(tol)~=2 | any(tol<0)
   error('TOL Must Contain Two Positive Numerical Values.')
end
[yl,yr]=mmspget(pp,'yl','yr');
yl=[yl;yr(end)];
yr=[yl(1);yr];
ix=find(abs(yl-yr)>(abs(yl)*tol(1) + tol(2)));

if nargout>1
   [yl,yr]=mmspget(pp,'dyl','dyr');
   yl=[yl;yr(end)];
   yr=[yl(1);yr];
   idx=find(abs(yl-yr)>(abs(yl)*tol(1) + tol(2)));
end

if nargout>2
   [yl,yr]=mmspget(pp,'ddyl','ddyr');
   yl=[yl;yr(end)];
   yr=[yl(1);yr];
   iddx=find(abs(yl-yr)>(abs(yl)*tol(1) + tol(2)));
end