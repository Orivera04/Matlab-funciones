function z=mmspder(x,y,xi)
%MMSPDER Spline Derivative Interpolation. (MM)
% YI=MMSPDER(X,Y,XI) uses cubic spline interpolation to fit the
% data in X and Y, differentiates the spline, and returns values
% of the spline derivatives evaluated at the points in XI.
%
% PPD=MMSPDER(PP) returns the piecewise polynomial vector PPD
% describing the spline derivative of the curve described by
% the piecewise polynomial in PP. PP is returned by the function
% SPLINE and MMSPLINE and is a data vector containing all information
% to evaluate and manipulate a spline. 
%
% YI=MMSPDER(PP,XI) differentiates the spline given by
% the piecewise polynomial PP, and returns the values of the
% spline derivatives evaluated at the points in XI.
%
% See also MMSPHELP 

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/27/95, renamed 5/19/96, v5: 1/14/97, 4/26/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==3
   pp=spline(x,y);
else
   pp=x;
end
[br,co,npy,nco]=unmkpp(pp);	% take apart pp
sf=nco-1:-1:1;							% scale factors for differentiation
dco=sf(ones(npy,1),:).*co(:,1:nco-1);	% derivative coefficients
ppd=mkpp(br,dco); 					    % build pp form for derivative
if nargin==1
   z=ppd;
elseif nargin==2
   z=mmppval(ppd,y);
else
   z=mmppval(ppd,xi);
end
