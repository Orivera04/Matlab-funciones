function S=scalar(X,varargin)
%SCALAR  Create scalar function.
%   S = SCALAR(XYZ,FUNC) where XYZ is a vector containing the range
%   and the number for points for X, Y and Z.
%   That is XYZ=[START END NUMPTS].
%   XYZ can also have the format XYZ=[START END] having the default
%   value of NUMPTS=21;
%   FUNC is a string which defines the scalar function.
%
%   S = SCALAR(X,Y,Z,FUNC) where X, Y and Z has the same syntax
%   as XYZ above.
%
%   S = SCALAR(XYZ,FUNC,COORDS)
%   S = SCALAR(X,Y,Z,FUNC,COORDS) where COORDS is one of
%   'cart', 'sph' or 'cyl'. Default is 'cart'.
%
%   S = SCALAR(FUNC[,COORDS]) where X, Y and Z will be the following
%   default values:
%                    X               Y             Z
%     Cartesian:   x = [-10 10],   y = [-10 10], z = [-10 10]
%     Cylindrical: r = [0 10],   phi = [0 2*pi], z = [-10 10]
%     Spherical:   R = [0 10], theta = [0 pi], phi = [0 2*pi]
%
%   Example:
%     f = scalar([-1 1],[0 1],[-1 0 6],'x^2+y')
%
%        Scalar function:
%        f(x,y,z) = x^2+y
%
%   See also VECTOR.

% Copyright (c) 2001-04-13, B. Rasmus Anthin.

inferiorto('vector')
error(nargchk(1,5,nargin))
arg=varargin;
min=-10;max=10;N=21;
Y=X;Z=X;
ni=nargin;
coords='cart';
if ni>1 & (strcmp(arg{end},'cart') | strcmp(arg{end},'sph') | strcmp(arg{end},'cyl'))
   coords=arg{end};
   ni=ni-1;
end

if ischar(X) | (ni==2 & ischar(arg{1})) |(ni==4 & ischar(arg{3}))
   if ni==1
      F=X;
      switch coords
      case {'cyl'}
         X=[0 max];
         Y=[0 2*pi];
         Z=[min max];
      case {'sph'}
         X=[0 max];
         Y=[0 pi];
         Z=[0 2*pi];
      otherwise
         X=[min max];
         Y=X;Z=X;
      end
   elseif ni==2
      F=arg{1};
   elseif ni==4
      Y=arg{1};Z=arg{2};
      F=arg{3};
   end
   if length(X)==2, X(3)=N;end
   if length(Y)==2, Y(3)=N;end
   if length(Z)==2, Z(3)=N;end
   FF=F;
   F=strrep(F,'*','.*');F=strrep(F,'^','.^');F=strrep(F,'\','.\');F=strrep(F,'/','./');
   S=struct('x',X,'y',Y,'z',Z,'xval',[],'yval',[],'zval',[],'f',FF,'F',F,'coords',coords);
   S=class(S,'scalar');
elseif isstruct(X)
   S=class(X,'scalar');
elseif isscalar(X)
   S=X;
elseif isnumeric(X) & length(X)==1
   S.x=[min max N];
   S.y=S.x;S.z=S.x;
   S.xval=[];S.yval=[];S.zval=[];
   S.f=cplxread(X);
   S.F=S.f;
   S.coords=coords;
   S=class(S,'scalar');
else
   error('Invalid argument(s).')
end
