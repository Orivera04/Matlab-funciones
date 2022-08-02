function V=vector(X,varargin)
%VECTOR  Create vector function.
%   V = VECTOR(XYZ,FUNCX,FUNCY,FUNCZ) where XYZ is a vector containing
%   the range and the number of points for X, Y and Z.
%   That is XYZ=[START END NUMPTS].
%   XYZ can also have the format XYZ=[START END] having the default
%   value of NUMPTS=21;
%   FUNCX through FUNCZ are strings which defines the vector
%   functions.
%
%   V = VECTOR(X,Y,Z,FUNCX,FUNCY,FUNCZ) where X, Y and Z has the
%   same syntax as XYZ above.
%
%   V = VECTOR(XYZ,FUNCX,FUNCY,FUNCZ,COORDS)
%   V = VECTOR(X,Y,Z,FUNCX,FUNCY,FUNCZ,COORDS) where COORDS is one of
%   'cart', 'sph' or 'cyl'. Default is 'cart'.
%
%   V = VECTOR(FUNCX,FUNCY,FUNCZ,[,COORDS]) where X, Y and Z will be
%   the following default values:
%                    X               Y             Z
%     Cartesian:   x = [-10 10],   y = [-10 10], z = [-10 10]
%     Cylindrical: r = [0 10],   phi = [0 2*pi], z = [-10 10]
%     Spherical:   R = [0 10], theta = [0 pi], phi = [0 2*pi]
%
%   Example:
%     f = vector([-1 1],[0 1],[-1 0 6],'x^2','y^2','z^2')
%
%        Vector functions:
%        f.x(x,y,z) = x^2
%        f.y(x,y,z) = y^2
%        f.z(x,y,z) = z^2
%
%   See also SCALAR.

% Copyright (c) 2001-04-13, B. Rasmus Anthin.

error(nargchk(1,7,nargin))
arg=varargin;
min=-10;max=10;N=21;
Y=X;Z=X;
ni=nargin;
coords='cart';
if ni>1 & (strcmp(arg{end},'cart') | strcmp(arg{end},'sph') | strcmp(arg{end},'cyl'))
   coords=arg{end};
   ni=ni-1;
end
  
if ischar(X) | (ni==4 & ischar(arg{3})) | (ni==6 & ischar(arg{5}))
   if ni==1
      Fx=X;Fy=X;Fz=X;
   elseif ni==3
      Fx=X;Fy=arg{1};Fz=arg{2};
   end
   if ni==1 | ni==3
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
   elseif ni==4
      Fx=arg{1};Fy=arg{2};Fz=arg{3};
   elseif ni==6
      Y=arg{1};Z=arg{2};
      Fx=arg{3};Fy=arg{4};Fz=arg{5};
   end
   if length(X)==2, X(3)=N;end
   if length(Y)==2, Y(3)=N;end
   if length(Z)==2, Z(3)=N;end
   FFx=Fx;FFy=Fy;FFz=Fz;
   Fx=strrep(Fx,'*','.*');Fx=strrep(Fx,'^','.^');Fx=strrep(Fx,'\','.\');Fx=strrep(Fx,'/','./');
   Fy=strrep(Fy,'*','.*');Fy=strrep(Fy,'^','.^');Fy=strrep(Fy,'\','.\');Fy=strrep(Fy,'/','./');
   Fz=strrep(Fz,'*','.*');Fz=strrep(Fz,'^','.^');Fz=strrep(Fz,'\','.\');Fz=strrep(Fz,'/','./');
   V=struct('x',X,'y',Y,'z',Z,'xval',[],'yval',[],'zval',[],...
      'fx',FFx,'fy',FFy,'fz',FFz,'Fx',Fx,'Fy',Fy,'Fz',Fz,'coords',coords);
   V=class(V,'vector');
elseif isstruct(X)
   V=class(X,'vector');
elseif isvector(X)
   V=X;
elseif isscalar(X)
   X=struct(X);
   V.x=X.x;V.y=X.y;V.z=X.z;
   V.xval=[];V.yval=[];V.zval=[];
   V.fx=X.f;V.fy=X.f;V.fz=X.f;
   V.Fx=X.F;V.Fy=X.F;V.Fz=X.F;
   V.coords=X.coords;
   V=class(V,'vector');
elseif isnumeric(X)
   V.x=[min max N];
   V.y=V.x;V.z=V.x;
   V.xval=[];V.yval=[];V.zval=[];
   switch(length(X))
   case 1
      V.fx=cplxread(X);
      V.fy=V.fx;V.fz=V.fx;
   case 3
      V.fx=cplxread(X(1));
      V.fy=cplxread(X(2));
      V.fz=cplxread(X(3));
   otherwise
      error('Invalid length of vector.');
   end
   V.Fx=V.fx;V.Fy=V.fy;V.Fz=V.fz;
   V.coords=coords;
   V=class(V,'vector');
else
   error('Invalid argument(s).');
end