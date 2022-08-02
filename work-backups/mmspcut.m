function z=mmspcut(pp,xmin,xmax)
%MMSPCUT Extract or Cut Out Part of a Spline. (MM)
% MMSPCUT(PP,Xmin,Xmax) or MMSPCUT(PP,[Xmin Xmax]) extracts
% the spline piecewise polynomial from PP, that contains the
% range [Xmin Xmax]. If Xmin<X(1) where X(1) is the first breakpoint
% in PP, Xmin=X(1). If Xmax>X(n) where X(n) is the last breakpoint in
% PP, Xmax=Xn. If max(Xmin,Xmax)<X(1) or min(Xmin,Xmax)>X(n) an empty
% matrix is returned. It is assumed that the spline is fit to data where
% X is monotonically increasing.
%
% MMSPCUT(PP,i) extracts the single polynomial in pp form that describes
% the spline between x(i) and x(i+1). An empty matrix is returned if
% i is outside the bounds of PP.
%
% See also MMSPHELP

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/22/96, v5: 1/14/97, 4/26/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

z=[];
[xbr,coefs,npolys,ncoefs]=unmkpp(pp);
nbr=npolys+1;
if nargin==2 & length(xmin)>1      % MMSPCUT(PP,[Xmin Xmax])
   xmax=xmin(2); xmin=xmin(1);
elseif nargin==2 & length(xmin)==1 % MMSPCUT(PP,i)
   i=fix(xmin);
   if i>0 & i<=npolys
      z=mkpp(xbr(i:i+1),coefs(i,:));
   end
   return
end
xmin=min(xmin,xmax);
xmax=max(xmin,xmax);
if xmax<xbr(1) | xmin>xbr(nbr), return, end

imin=find(xbr>xmin);    % breakpoints greater than xmin
imin=max(imin(1)-1,1);  % go back one breakpoint

imax=find(xbr>xmax);    % breakpoints greater than xmax
if isempty(imax), imax=nbr;
else,             imax=imax(1);
end

xbr=xbr(imin:imax);         % get new breakpoints  
coefs=coefs(imin:imax-1,:); % get new polynomials
z=mkpp(xbr,coefs);          % build new pp vector
