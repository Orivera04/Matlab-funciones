function handle = vfield(x,y,u,v,varargin)
%VFIELD   Plot 2D velocity field
%
%   Syntax:
%      HANDLE = VFIELD(X,Y,U,V,VARARGIN)
%
%   Inputs:
%      X, Y     Arrows origin, N-D arrays
%      U, V     Current components, N-D arrays
%      VARARGIN:
%         C, patches CData
%         'color', <color> line/patch color [ 'k' ]
%         'fill', [ {0} | 1 ], fill arrows tip
%         'tr', <val>, tip length with respect to intensity or
%            absolute length if is a string
%            [ <value> <value as string> {0.1} ]
%        'fi', <deg>, tip angle [ 30 ]
%        'z', <val>, z level, value or array size x, y, u and v [ 0 ]
%
%   Output:
%      HANDLE   Handle for the lines (if no CData is used) or for
%               patches
%
%   Example:
%      figure
%      [x,y] = meshgrid(-2:.2:2,-1:.15:1);
%      z = x .* exp(-x.^2 - y.^2);
%      [u,v] = gradient(z,.2,.15);
%      vfield(x,y,.3*u,.3*v,z), colorbar
%      axis equal
%
%   MMA 28-7-2005, martinho@fis.ua.pt
%
%   See also VFIELD3

%   Department of Physics
%   University of Aveiro, Portugal

handle=[];

Fi     = 30;
a      = .1;
color  = 'k';
fillit = 0;
z      = 0;
useC   = 0;
if nargin < 4
  error('x, y, u and v are needed');
  return
end

for i=1:length(varargin)
  vin = varargin{i};
  if isnumeric(varargin{1});
    C = varargin{1};
    useC = 1;
  end
  if isequal(vin,'color')
    color = varargin{i+1};
  end
  if isequal(vin,'fill')
    fillit = varargin{i+1};
  end
  if isequal(vin,'tr')
    a = varargin{i+1};
  end
  if isequal(vin,'fi')
    Fi = varargin{i+1};
  end
  if isequal(vin,'z')
    z = varargin{i+1};
  end
end

% no plot if 0:
u(u==0 & v==0) = nan;
x(isnan(u)) = nan;

n = prod(size(x));
x = reshape(x,1,n);
y = reshape(y,1,n);
if prod(size(z)) == 1, z = repmat(z,size(x)); end
u = reshape(u,1,n);
v = reshape(v,1,n);
speed = sqrt(u.^2 + v.^2);
ang   = atan2(v,u);
Fi    = Fi*pi/180;
if ~isstr(a), r = speed*a;
else          r = repmat(str2num(a),size(speed)); end
tt  = atan(r./(speed-r)*tan(Fi));
P1x = x+(speed-r)./cos(tt).*cos(ang+tt);
P2x = x+(speed-r)./cos(tt).*cos(ang-tt);
P1y = y+(speed-r)./cos(tt).*sin(ang+tt);
P2y = y+(speed-r)./cos(tt).*sin(ang-tt);

if ~fillit & ~useC
  theView = view;
  tmpx = [x; x+u; P1x; ;x+u; P2x; repmat(nan,size(x))];
  tmpy = [y; y+v; P1y; ;y+v; P2y; repmat(nan,size(x))];
  tmpz = [z;   z;   z;    z;   z; repmat(nan,size(x))];
  u_ = reshape(tmpx,1,6*n);
  v_ = reshape(tmpy,1,6*n);
  z_ = reshape(tmpz,1,6*n);
  handle = plot3(u_,v_,z_,'color',color);
  view(theView);
else
  % about patches:
  if ~fillit, r=0; end
  Faces = 1:6*n; Faces = reshape(Faces,6,n)';
  Vert = repmat(0,6*n,3);
  us = u-r.*cos(ang);
  vs = v-r.*sin(ang);
  Vert(:,1) = reshape([x; x+us; P1x; x+u; P2x; x+us],6*n,1);
  Vert(:,2) = reshape([y; y+vs; P1y; y+v; P2y; y+vs],6*n,1);
  Vert(:,3) = reshape([z     z    z    z    z     z],6*n,1);
  if useC
    C = reshape(repmat(reshape(C,1,n),6,1),6*n,1);
    handle = patch(Vert(:,1),Vert(:,2),Vert(:,3),C);
    set(handle,'Faces', Faces,'edgecolor','interp');
  else
    handle = patch(Vert(:,1),Vert(:,2),Vert(:,3),color);
    set(handle,'Faces', Faces,'edgecolor',color);
  end
end
