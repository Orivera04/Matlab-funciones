function varargout = drawSphere(varargin)
%DRAWSPHERE draw a sphere as a mesh
%
%   drawSphere(XC, YC, ZC, R)
%   drawSphere([XC YC ZC], R)
%   drawSphere([XC YC ZC R])
%
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 17/02/2005
%

%   HISTORY
%   2006-05-19 : use centered sphere with radius 1 when no input specified
%   04/01/2007: typo

options = {};
for i=1:length(varargin)
    if ischar(varargin{i})        
        options = varargin(i:end);
        varargin = varargin(1:i-1);
        break;
    end
end


if isempty(varargin)
    xc = 0;	yc = 0; zc = 0;
    r = 1;    
elseif length(varargin)==1
    sphere = varargin{1};
    xc = sphere(:,1);
    yc = sphere(:,2);
    zc = sphere(:,3);
    r  = sphere(:,4);
elseif length(varargin)==2
    center = varargin{1};
    xc = center(1);
    yc = center(2);
    zc = center(3);
    r  = varargin{2};
elseif length(varargin)==4
    xc = varargin{1};
    yc = varargin{2};
    zc = varargin{3};
    r  = varargin{4};
else
    error('drawSphere : please specify center and radius');
end

nphi = 32;
ntheta = 16;

theta = (0:ntheta)/ntheta*pi;
phi = (0:nphi)/nphi*2*pi;

sintheta = sin(theta);

x = xc + cos(phi')*sintheta*r;
y = yc + sin(phi')*sintheta*r;
z = zc + ones(length(phi),1)*cos(theta)*r;


if nargout == 0
    surf(x,y,z, 'FaceColor', 'g', options{:});
elseif nargout == 1
    varargout{1} = surf(x,y,z, 'FaceColor', 'g', options{:});
elseif nargout == 3
    varargout{1} = x; 
    varargout{2} = y; 
    varargout{3} = z; 
end

