function z=mmspint(varargin)
%MMSPINT Spline Integral Interpolation. (MM)
% YI=MMSPINT(X,Y,XI,C) uses cubic spline interpolation to fit the
% data in X and Y, integrates the spline with integration constant C,
% and returns values of the integral evaluated at the points in XI.
%
% PPI=MMSPINT(PP,C) returns the piecewise polynomial vector PPI
% describing the integral of the spline described by the
% piecewise polynomial in PP and having integration constant C.
% PP is returned by the functions SPLINE and MMSPLINE and is a data
% vector containing all information to evaluate and manipulate a spline.
%
% YI=MMSPINT(PP,XI,C) integrates the spline given by the piecewise
% polynomial PP and integration constant C, and returns the
% values of the integral evaluated at the points in XI.
%
% The integration constant C must be provided.
% See also MMSPHELP

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/27/95, renamed 5/19/96 v5: 1/14/97, 4/26/99, 6/29/00
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==4     % MMSPINT(X,Y,XI,C)
   pp=spline(varargin{1},varargin{2});
   xi=varargin{3};
   C=varargin{4};
elseif nargin==3 % MMSPINT(PP,XI,C)
   pp=varargin{1};
   xi=varargin{2};
   C=varargin{3};
elseif nargin==2 % MMSPINT(PP,C)
   pp=varargin{1};
   xi=[];
   C=varargin{2};
else
   error('Imcorrent Number of Input Arguments.')
end
if prod(size(C))~=1
   error('C Must be a Scalar.')
end
[br,co,npy,nco,ndim]=unmkpp(pp);	   % take apart pp
if ndim>1
   error('1-D Spline Required.')
end
sf=nco:-1:1;								% scale factors for integration
ico=[co./sf(ones(npy,1),:) zeros(npy,1)];	% integral coefficients
nco=nco+1;									% integral spline has higher order
dx=diff(br(:));
tmp=ico(:,1);
for i=2:nco
   tmp=dx.*tmp + ico(:,i);
end
ico(:,end)=cumsum([C;tmp(1:end-1)]);
ppi=mkpp(br,ico);
if nargin==2
   z=ppi;
elseif nargin==3
   z=mmppval(ppi,y);
else
   z=mmppval(ppi,xi);
end
