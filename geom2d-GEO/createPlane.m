function plane = createPlane(varargin)
%CREATEPLANE create a plane in parametrized form
%
%   Create a plane in the following format : 
%   PLANE = [X0 Y0 Z0  DX1 DY1 DZ1  DX2 DY2 DZ2], where :
%   - (X0, Y0, Z0) is a point belonging to the plane
%   - (DX1, DY1, DZ1) is a first direction vector
%   - (DX2, DY2, DZ2) is a second direction vector
%   The 2 direction vectors are normalized and orthogonal.
%
%
%   PLANE = createPlane(P1, P2, P3) 
%   create a plane containing the 3 points
%
%   PLANE = createPlane(PTS) 
%   The 3 points are packed into a single 3x3 array.
%
%   PLANE = createPlane(P0, N);
%   create a plane from a point and from a normal to the plane. parameterN
%   is given as [THETA PHI], where THETA is the colatitute (angle with the
%   vertical axis) and PHI is angle with Ox axis, coutned
%   counter-clockwise. Both are given in radians.
%   
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 18/02/2005.
%

%   HISTORY :
%   24/11/2005 : add possibility to pack points for plane creation
%   21/08/2006 : return normalized planes
%   06/11/2006 : update doc for planes created from normal

if length(varargin)==1
    var = varargin{1};
    
    if iscell(var)
        plane = zeros([0 9]);
        for i=1:length(var)
            plane = [plane; createPlane(var{i})];
        end
    elseif size(var, 1)==3
        % 3 points in a single array
        p1 = var(1,:);
        p2 = var(2,:);
        p3 = var(3,:);
        
        % create direction vectors
        v1 = p2-p1;
        v2 = p3-p1;

        % create plane
        plane = normalizePlane([p1 v1 v2]);
        return;
    end
    
elseif length(varargin)==2
    
    p0 = varargin{1};
    
    var = varargin{2};
    if size(var, 2)==2
        n = sph2cart2([var ones(size(var, 1))]);
    elseif size(var, 2)==3
        n  = normalize3d(var);
    else
        error ('wrong number of parameters in createPlane');
    end
    
    % find a vector not colinear to the normal
    v0 = repmat([1 0 0], [size(p0, 1) 1]);    
    if abs(cross(n, v0, 2))<1e-14
        v0 = repmat([0 1 0], [size(p0, 1) 1]);
    end
    
    % create direction vectors
    v1 = normalize3d(cross(n, v0, 2));
    v2 = -normalize3d(cross(v1, n, 2));
    
    plane = [p0 v1 v2];
    return;
    
elseif length(varargin)==3
    p1 = varargin{1};    
    p2 = varargin{2};
    p3 = varargin{3};
    
    % create direction vectors
    v1 = p2-p1;
    v2 = p3-p1;
   
    plane = normalizePlane([p1 v1 v2]);
    return;
  
else
    error('wrong number of arguments in "createPlane".');
end

