function varargout = transformPoint3d(varargin)
%TRANSFORMPOINT3D transform a point with a 3D affine transform
%
%   PT2 = transformPoint3d(PT1, TRANS).
%   where PT1 has the form [xp yp zp], and TRANS is a [3x3], [3x4], [4x4]
%   matrix, return the point transformed according to the affine transform
%   specified by TRANS.
%
%   Format of TRANS can be one of :
%   [a b c]   ,   [a b c j] , or [a b c j]
%   [d e f]       [d e f k]      [d e f k]
%   [g h i]       [g h i l]      [g h i l]
%                                [0 0 0 1]
%
%   PT2 = transformPoint3d(PT1, TRANS) also work when PTA is a [Nx3] array
%   of double. In this case, PT2 has the same size as PT1.
%
%   See also :
%   translation3d
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 10/02/2005.
%

%   23/03/2006 add support for non vector point data
%   26/10/2006 better support for large data handling : iterate on points
%       in the case of a memory lack.

% process input arguments
if length(varargin)==2
    points = varargin{1};
    x = points(:,1);
    y = points(:,2);
    z = points(:,3);
    trans  = varargin{2};
    clear points;
elseif length(varargin)==4
    x = varargin{1};
    y = varargin{2};
    z = varargin{3};
    trans = varargin{4};
end

% keep initial dimension of input vector
dim = size(x); 
NP = length(x(:));
%points = [x(:) y(:) z(:) ones(NP, 1)];

% eventually add null translation
if size(trans, 2)==3
    trans = [trans zeros(size(trans, 1), 1)];
end

% eventually add normalization
if size(trans, 1)==3
    trans = [trans;0 0 0 1];
end

%old version, but bad results 
%res = [point ones(size(point, 1), 1)]*trans';

% convert coordinates
try
    % vectorial processing, if there is enough memory
    %res = (trans*[x(:) y(:) z(:) ones(NP, 1)]')';
    res = [x(:) y(:) z(:) ones(NP, 1)]*trans';
    
    % reshape data to original size
    x = reshape(res(:,1), dim);
    y = reshape(res(:,2), dim);
    z = reshape(res(:,3), dim);
catch
    % process each point one by one
    for i=1:length(x(:))
        res = [x(i) y(i) z(i) 1]*trans';
        x(i) = res(1);
        y(i) = res(2);
        z(i) = res(3);
    end
end


% process output arguments
if nargout==1 || nargout==0
    if length(dim)>2 || dim(2)>1
        varargout{1} = {x, y, z};
    else
        varargout{1} = [x y z];
    end
elseif nargout==3
    varargout{1} = x;
    varargout{2} = y;
    varargout{3} = z;
end   
