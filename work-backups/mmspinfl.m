function [x,y,pn]=mmspinfl(pp,xlim)
%MMSPINFL Spline Inflection Points. (MM)
% [X,Y,S]=MMSPINFL(PP) returns the points X where the piecewise polynomial PP
% has zero curvature. Y=PPVAL(PP,X) and S is a vector containing the spline
% slopes at the points in X.
%
% MMSPINFL(PP,Xlim) limits the search to the interval Xlim=[Xmin Xmax].
%
% See also MMSPHELP

% Calls: mmspcut, mmspder, mmspii

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 3/23/99, 4/26/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1, xlim=[];
elseif nargin~=2, error('Incorrect Number of Input Arguments.')
end

if ~isempty(xlim)
   pp=mmspcut(pp,xlim);
end
ppd=mmspder(pp);
ppc=mmspder(ppd);

x=mmspii(ppc,0);

if nargout>=2
   y=mmppval(pp,x);
end
if nargout==3
   pn=mmppval(ppd,x);
end
