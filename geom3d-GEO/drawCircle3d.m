function varargout = drawCircle3d(varargin)
%DRAWCIRCLE3D draw a 3D circle
%
%   Possible calls for the function :
%   drawCircle3d([XC YC ZC R PHI THETA])
%   drawCircle3d([XC YC ZC R PHI THETA PSI])
%   drawCircle3d([XC YC ZC R], [PHI THETA])
%   drawCircle3d([XC YC ZC R], [PHI THETA PSI])
%   drawCircle3d([XC YC ZC R], PHI, THETA)
%   drawCircle3d([XC YC ZC], R, PHI, THETA)
%   drawCircle3d([XC YC ZC R], PHI, THETA, PSI)
%   drawCircle3d([XC YC ZC], R, PHI, THETA, PSI)
%   drawCircle3d(XC, YC, ZC, R, PHI, THETA)
%   drawCircle3d(XC, YC, ZC, R, PHI, THETA, PSI)
%
%   where XC, YC, ZY are coordinate of circle center, R is the radius of he
%   circle, PHI and THETA are 3D angle of the normal to the plane
%   containing the circle (PHI between 0 and 2xPI corresponding to
%   longitude, and THETA from 0 to PI, corresponding to angle with
%   vertical).
%   
%   H = drawCircle3d(...)
%   return handle on the created LINE object
%   
%   TODO: use angle convention [THETA PHI PSI] with THETA=colatitude
%
%   ------
%   Author: David Legland
%   e-mail: david.legland@jouy.inra.fr
%   Created: 2005-02-17
%   Copyright 2005 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas).

%   HISTORY
%   14/12/2006: allows unspecified PHI and THETA
%   04/01/2007: update doc, add todo for angle convention

%   Possible calls for the function, with number of arguments :
%   drawCircle3d([XC YC ZC R PHI THETA])            1
%   drawCircle3d([XC YC ZC R PHI THETA PSI])        1
%   drawCircle3d([XC YC ZC R], [PHI THETA])         2
%   drawCircle3d([XC YC ZC R], [PHI THETA PSI])     2
%   drawCircle3d([XC YC ZC R], PHI, THETA)          3
%   drawCircle3d([XC YC ZC], R, PHI, THETA)         4
%   drawCircle3d([XC YC ZC R], PHI, THETA, PSI)     4
%   drawCircle3d([XC YC ZC], R, PHI, THETA, PSI)    5
%   drawCircle3d(XC, YC, ZC, R, PHI, THETA)         6
%   drawCircle3d(XC, YC, ZC, R, PHI, THETA, PSI)    7


if length(varargin)==1
    % get center and radius
    circle = varargin{1};
    xc = circle(:,1);
    yc = circle(:,2);
    zc = circle(:,3);
    r  = circle(:,4);
    
    % get azimut of normal
    if size(circle, 2)>=5
        phi     = circle(:,5);
    else
        phi = zeros(size(circle, 1), 1);
    end
    
    % get colatitude of normal
    if size(circle, 2)>=6
        theta = circle(:,6);
    else
        theta = zeros(size(circle, 1), 1);
    end

    % get roll
    if size(circle, 2)==7
        psi = circle(:,7);
    else
        psi = zeros(size(circle, 1), 1);
    end
    
elseif length(varargin)==2
    % get center and radius
    circle = varargin{1};
    xc = circle(:,1);
    yc = circle(:,2);
    zc = circle(:,3);
    r  = circle(:,4);
    
    % get angle of normal
    angle = varargin{2};
    phi     = angle(:,1);
    theta   = angle(:,2);
    
    % get roll
    if size(angle, 2)==3
        psi = angle(:,3);
    else
        psi = zeros(size(angle, 1), 1);
    end

elseif length(varargin)==3    
    % get center and radius
    circle = varargin{1};
    xc = circle(:,1);
    yc = circle(:,2);
    zc = circle(:,3);
    r  = circle(:,4);
    
    % get angle of normal and roll
    phi     = varargin{2};
    theta   = varargin{3};
    psi     = zeros(size(phi, 1), 1);
    
elseif length(varargin)==4
    % get center and radius
    circle = varargin{1};
    xc = circle(:,1);
    yc = circle(:,2);
    zc = circle(:,3);
    
    if size(circle, 2)==4
        r   = circle(:,4);
        phi     = varargin{2};
        theta   = varargin{3};
        psi     = varargin{4};
    else
        r   = varargin{2};
        phi     = varargin{3};
        theta   = varargin{4};
        psi     = zeros(size(phi, 1), 1);
    end
    
elseif length(varargin)==5
    % get center and radius
    circle = varargin{1};
    xc = circle(:,1);
    yc = circle(:,2);
    zc = circle(:,3);
    r  = varargin{2};
    phi     = varargin{3};
    theta   = varargin{4};
    psi     = varargin{5};

elseif length(varargin)==6
    xc      = varargin{1};
    yc      = varargin{2};
    zc      = varargin{3};
    r       = varargin{4};
    phi     = varargin{5};
    theta   = varargin{6};
    psi     = zeros(size(phi, 1), 1);
  
elseif length(varargin)==7   
    xc      = varargin{1};
    yc      = varargin{2};
    zc      = varargin{3};
    r       = varargin{4};
    phi     = varargin{5};
    theta   = varargin{6};
    psi     = varargin{7};

else
    error('DRAWCIRCLE3D: please specify center and radius');
end

N = 64;
t = [0:2*pi/N:2*pi*(1-1/N) 2*pi];


x = r*cos(t)';
y = r*sin(t)';
z = zeros(length(t), 1);

circle0 = [x y z];

tr = translation3d(xc, yc, zc);
rot1 = rotationOz(psi);
rot2 = rotationOy(-theta);
rot3 = rotationOz(-phi);
trans = tr*rot3*rot2*rot1;

circle = transformPoint3d(circle0, trans);

h = drawCurve3d(circle);


if nargout>0
    varargout{1}=h;
end

