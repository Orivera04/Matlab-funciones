function [xi,yi,pn]=mmspxtrm(pp,xlim)
%MMSPXTRM Spline Extremes. (MM)
% [Xi,Yi,C]=MMSPXTRM(PP) interpolates the piecewise polynomial PP,
% to find the points Xi and Yi where the spline has zero slope.
% C is a vector containing the curvature of the spline at Xi.
% 
% MMSPXTRM(PP,Xlim) limits the search to the interval Xlim=[Xmin Xmax];
%
% See also MMSPHELP

% Calls: mmspcut, mmspder, mmspii

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 3/13/97, 3/22/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1, xlim=[];
elseif nargin~=2, error('Incorrect Number of Input Arguments.')
end

if ~isempty(xlim)
   pp=mmspcut(pp,xlim);
end

ppd=mmspder(pp);   % spline slopes
xi=mmspii(ppd,0);  % x values where slope is zero
if isempty(xi)     % no extremes!
   yi=[];
   pn=[];
else
   yi=mmppval(pp,xi);   % y values where slope is zero
   if nargout==3
      ppdd=mmspder(ppd); % spline curvatures
      pn=mmppval(ppdd,xi);
   end
end
