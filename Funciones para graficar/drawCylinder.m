function varargout = drawCylinder(cyl, varargin)
%DRAWCYLINDER draw a cylinder
%
%   usage :
%   drawCylinder(CYL)
%   where CYL is a cylinder defined by [x1 y2 z1 x2 y2 z2 r], from starting
%   and ending point of cylinder, together with radius, draws the
%   corresponding shape on the current axis.
%
%   drawCylinder(CYL, N)
%   uses N points for discretisation of angle
%
%   
%   drawCylinder(..., OPT)
%   with OPT = 'open' or 'closed', specify if bases of cylinder should be
%   drawn.
%
%   Example:
%   drawCylinder([0 0 0 10 20 30 5]);
%
%   See Also:
%   drawSphere, drawLine3d
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 17/09/2005
%

%   HISTORY
%   2006/12/14 bug for coordinate conversion, vectorize transforms
%   04/01/2007: better input processing, manage end caps of cylinder


if iscell(cyl)
    res = zeros(length(cyl), 1);
    for i=1:length(cyl)
        res(i) = drawCylinder(cyl{i}, varargin{:});
    end
    
    if nargout>0
        varargout{1} = res;
    end    
    return;
end

% default values
N = 32;
closed = false;

% check number of discretization steps
if length(varargin)>0
    var = varargin{1};
    if isnumeric(var)
        N = var;
        varargin = varargin(2:end);
    end
end

% check if cylinder must be closed or open
if length(varargin)>0
    var = varargin{1};
    if ischar(var)
        if strncmpi(var, 'open', 4)
            closed = false;
            varargin = varargin(2:end);
        elseif strncmpi(var, 'closed', 5)
            closed = true;
            varargin = varargin(2:end);
        end
    end
end

% compute orientation angle of cylinder
[theta phi rho] = cart2sph2(cyl(4:6)-cyl(1:3));
dphi = 0:2*pi/N:2*pi;

% radius of cylinder
r = cyl(7);

% points of cylinder
x = repmat(cos(dphi)*r, [2 1]);
y = repmat(sin(dphi)*r, [2 1]);
z = repmat([0;rho], [1 length(dphi)]);

% transform points
tra = translation3d(cyl(1:3));
roZ = rotationOz(-phi);
roY = rotationOy(-theta);
trans = tra*roZ*roY;
pts = transformPoint3d([x(:) y(:) z(:)], trans);

% reshape transformed points
x2 = reshape(pts(:,1), size(x));
y2 = reshape(pts(:,2), size(x));
z2 = reshape(pts(:,3), size(x));

% default drawing options
if isempty(varargin)
    varargin = {'FaceColor', 'g', 'edgeColor', 'none'};
end

% plot the cylinder as a surface
hSurf = surf(x2, y2, z2, varargin{:});

% eventually plot the ends of the cylinder
if closed
    patch(x2(1,:)', y2(1,:)', z2(1,:)', 'g');
    patch(x2(2,:)', y2(2,:)', z2(2,:)', 'g');
end

% format ouptut
if nargout == 1
    varargout{1} = hSurf;
end
