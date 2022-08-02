function lh=plot(f,varargin)
%PLOT  Plot vector function.
%   PLOT(V[,COLOR]) plots the vector function using command QUIVER3.
%   However if V = V(X,Y,Z), then it will plot the vector
%   as a constant space vector rather than a vector field.
%   LH = PLOT(V[,COLOR]) returns a legend handle for the case when
%   V is constant.
%
%   PLOT(V,'slice') plots three plots of V using command SLICE.
%   Each plot corresponds to each of the function elements in V,
%   that is Vx,Vy and Vz.
%
%   PLOT(V,X,Y,Z,'slice') is the same as above but uses the vectors
%   X,Y and Z when slicing the vector components.
%
%   PLOT(V[,COLOR]) plots the vector function as a 2D field.
%   V = V(X,Y,Z) where exactly two of X, Y and Z must be set to [].
%   E.g. PLOT(V([],[],0)).
%
%   See also SLICE, QUIVER, QUIVER3.

% Copyright (c) 2001-04-13, B. Rasmus Anthin.

error(nargchk(1,5,nargin))
[xs ys zs]=vars(f);
xst=xs;yst=texstring(ys);zst=texstring(zs);
if nargin==1
   last='';
   color='b';
else
   last=varargin{end};
   color=varargin{1};
end
X=linspace(f.x(1),f.x(2),f.x(3));
Y=linspace(f.y(1),f.y(2),f.y(3));
Z=linspace(f.z(1),f.z(2),f.z(3));
echo off;
eval(['[' xs ',' ys ',' zs ']=meshgrid(X,Y,Z);']);
vars=eval(['{' xs ',' ys ',' zs '}']);
if (~isempty(f.xval) & f.xval(1)=='*') |...
      (~isempty(f.yval) & f.yval(1)=='*') |...
      (~isempty(f.zval) & f.zval(1)=='*')
   error('Cannot plot with undefined variable values. Assign a value to them first.')
end
if isempty(f.xval), xval=xst;xv=nan;else xval=f.xval;xv=str2num(f.xval);end
if isempty(f.yval), yval=yst;yv=nan;else yval=f.yval;yv=str2num(f.yval);end
if isempty(f.zval), zval=zst;zv=nan;else zval=f.zval;zv=str2num(f.zval);end
[ix iy iz]=index(vars{1},vars{2},vars{3},xv,yv,zv);
Fx=eval(f.Fx);Fy=eval(f.Fy);Fz=eval(f.Fz);
name=inputname(1);
name=texstring(name);
if isempty(name), name='ans';end
f.fx=strrep(f.fx,'^(','\^(');      %temporary solution
f.fy=strrep(f.fy,'^(','\^(');
f.fz=strrep(f.fz,'^(','\^(');
f.fx=texstring(f.fx);
f.fy=texstring(f.fy);
f.fz=texstring(f.fz);
isx=~isempty(f.xval);
isy=~isempty(f.yval);
isz=~isempty(f.zval);
if length(Fx)==1, Fx=Fx*ones(size(eval(xs)));end
if length(Fy)==1, Fy=Fy*ones(size(eval(ys)));end
if length(Fz)==1, Fz=Fz*ones(size(eval(zs)));end
if strcmp(lower(last),'slice')
   [xslice yslice zslice]=slices(f,varargin,nargin-2);
   if isconst(f,1), Fx=setcorners(Fx);end
   if isconst(f,2), Fy=setcorners(Fy);end
   if isconst(f,3), Fz=setcorners(Fz);end
   figure(gcf)
   eval(['slice(' xs ',' ys ',' zs ',Fx,xslice,yslice,zslice)'])
   xlabel(xst),ylabel(yst),zlabel(zst)
   title([name '_' xst '(' xval ',' yval ',' zval ') = ' f.fx])
   colorbar
   axis tight
   shading flat
   edges(gcf,xslice,yslice,zslice)
   rotate3d on
   figure
   eval(['slice(' xs ',' ys ',' zs ',Fy,xslice,yslice,zslice)'])
   xlabel(xst),ylabel(yst),zlabel(zst)
   title([name '_' yst '(' xval ',' yval ',' zval ') = ' f.fy])
   colorbar
   axis tight
   shading flat
   edges(gcf,xslice,yslice,zslice)
   rotate3d on
   figure
   eval(['slice(' xs ',' ys ',' zs ',Fz,xslice,yslice,zslice)'])
   xlabel(xst),ylabel(yst),zlabel(zst)
   title([name '_' zst '(' xval ',' yval ',' zval ') = ' f.fz])
   colorbar
   axis tight
   shading flat
   edges(gcf,xslice,yslice,zslice)
   rotate3d on
elseif sum([isx isy isz])==3 | (isconst(f,1) & isconst(f,2) & isconst(f,3))
   if isnan(xv), xv=0;end
   if isnan(yv), yv=0;end
   if isnan(zv), zv=0;end
   Lx=str2num(f.Fx);Ly=str2num(f.Fy);Lz=str2num(f.Fz);
   view(3)
   lhp=plot3(xv+[0 Lx],yv+[0 Ly],zv+[0 Lz],color);
   held=ishold;hold on
   plot3(xv+Lx,yv+Ly,zv+Lz,'ks')
   if ~held,hold off,end
   grid on
   xlabel(xst),ylabel(yst),zlabel(zst)
   title([name '(' xval ',' yval ',' zval ') = ( ' f.fx ' , ' f.fy ' , ' f.fz ' )'])
   view(3)
   rotate3d on
   if nargout, lh=lhp;end
elseif sum([isx isy isz])==1
   sq='squeeze';
   if isx & ~isy & ~isz
      idx='(:,ix,:)';
      eval(['quiver(' sq '(' ys idx '),' sq '(' zs idx '),' sq '(Fy' idx '),' sq '(Fz' idx '),color)'])
      xlabel(yst);ylabel(zst);
   elseif ~isx & isy & ~isz
      idx='(iy,:,:)';
      eval(['quiver(' sq '(' xs idx '),' sq '(' zs idx '),' sq '(Fx' idx '),' sq '(Fz' idx '),color)'])
      xlabel(xst);ylabel(zst);
   elseif ~isx & ~isy & isz
      idx='(:,:,iz)';
      eval(['quiver(' sq '(' xs idx '),' sq '(' ys idx '),' sq '(Fx' idx '),' sq '(Fy' idx '),color)'])
      xlabel(xst);ylabel(yst);
   end
   title([name '(' xval ',' yval ',' zval ') = ( ' f.fx ' , ' f.fy ' , ' f.fz ' )'])
else
   N=21;
   bigx=f.x(3)>N;
   bigy=f.y(3)>N;
   bigz=f.z(3)>N;
   Xi=X;Yi=Y;Zi=Z;
   if bigx | bigy | bigz
      warns=warning;
      if ~strcmp(warns,'off'),warning on,end
      warning('To many points in vector-field. Scaling down...')
      warning(warns)
   end
   if bigx, Xi=linspace(f.x(1),f.x(2),N);end
   if bigy, Yi=linspace(f.y(1),f.y(2),N);end
   if bigz, Zi=linspace(f.z(1),f.z(2),N);end
   if bigx | bigy | bigz
      [xi yi zi]=meshgrid(Xi,Yi,Zi);
      Fx=eval(['interp3(' xs ',' ys ',' zs ',Fx,xi,yi,zi,''cubic'')']);
      Fy=eval(['interp3(' xs ',' ys ',' zs ',Fy,xi,yi,zi,''cubic'')']);
      Fz=eval(['interp3(' xs ',' ys ',' zs ',Fz,xi,yi,zi,''cubic'')']);
      eval([xs '=xi;']),eval([ys '=yi;']),eval([zs '=zi;'])
   end
   eval(['quiver3(' xs ',' ys ',' zs ',Fx,Fy,Fz,color)'])
   xlabel(xst),ylabel(yst),zlabel(zst)
   title([name '(' xval ',' yval ',' zval ') = ( ' f.fx ' , ' f.fy ' , ' f.fz ' )'])
   rotate3d on
end
warns=warning;warning off
axis tight
warning(warns)