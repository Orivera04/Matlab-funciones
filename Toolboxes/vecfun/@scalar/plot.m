function plot(f,varargin)
%PLOT  Plot scalar function.
%   PLOT(S) plots the scalar function S using command SLICE.
%   The scalar S is sliced in the middle of all ranges X,Y and Z.
%
%   PLOT(S,X,Y,Z) does the same as above but slices up S using
%   the vectors X,Y and Z (see SLICE).
%
%   PLOT(S) plots S as a surface. S = S(X,Y,Z) where exactly
%   two of X, Y and Z must be set to [].
%   E.g. PLOT(S([],5,[])).
%
%   PLOT(S[,COLOR]) plots S using the command PLOT. S = S(X,Y,Z) where
%   exactly one of X, Y and Z must be set to [].
%   E.g. PLOT(S(0,pi,[])).
%
%   See also SLICE, SURF, PLOT.

% Copyright (c) 2001-04-13, B. Rasmus Anthin.
% 2001-04-17

error(nargchk(1,4,nargin))
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
eval(['[' xs ',' ys ',' zs ']=meshgrid(X,Y,Z);'])
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
F=eval(f.F);
name=inputname(1);
name=texstring(name);
if isempty(name), name='ans';end
f.f=strrep(f.f,'^(','\^(');      %temporary solution
f.f=texstring(f.f);
isx=~isempty(f.xval);
isy=~isempty(f.yval);
isz=~isempty(f.zval);
if length(F)==1, F=F*ones(size(eval(xs)));end
sq='squeeze';
if sum([isx isy isz])==1
   if isx & ~isy & ~isz
      idx='(:,ix,:)';
      eval(['surf(' sq '(' ys idx '),' sq '(' zs idx '),' sq '(F' idx '))'])
      xlabel(yst),ylabel(zst)
   elseif ~isx & isy & ~isz
      idx='(iy,:,:)';
      eval(['surf(' sq '(' xs idx '),' sq '(' zs idx '),' sq '(F' idx '))'])
      xlabel(xst),ylabel(zst)
   elseif ~isx & ~isy & isz
      idx='(:,:,iz)';
      eval(['surf(' sq '(' xs idx '),' sq '(' ys idx '),' sq '(F' idx '))'])
      xlabel(xst),ylabel(yst)
   end
   zlabel('f');
   colorbar
elseif sum([isx isy isz])==2
   if ~isx & isy & isz
      idx='(iy,:,iz)';
      eval(['plot(' sq '(' xs idx '),' sq '(F' idx '),color)'])
      xlabel(xst)
   elseif isx & ~isy & isz
      idx='(:,ix,iz)';
      eval(['plot(' sq '(' ys idx '),' sq '(F' idx '),color)'])
      xlabel(yst)
   elseif isx & isy & ~isz
      idx='(iy,ix,:)';
      eval(['plot(' sq '(' zs idx '),' sq '(F' idx '),color)'])
      xlabel(zst)
   end
   ylabel('f')
   grid
else
   [xslice yslice zslice]=slices(f,varargin,nargin-1);
   if isconst(f), F=setcorners(F);end
   eval(['slice(' xs ',' ys ',' zs ',F,xslice,yslice,zslice)'])
   xlabel(xst),ylabel(yst),zlabel(zst)
   colorbar
   axis tight
   shading flat
   edges(gcf,xslice,yslice,zslice)
   %rotate3d
end
title([name '(' xval ',' yval ',' zval ') = ' f.f])