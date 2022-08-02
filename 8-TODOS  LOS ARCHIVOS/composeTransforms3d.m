function trans = composeTransforms3d(varargin)
%COMPOSETRANSFORMS3D concatenate several space transformations
%
%   TRANS = composeTransforms3d(TRANS1, TRANS2, ...);
%   compute the affine transform equivalent to performing successively
%   TRANS1, TRANS2, ...
%   
%   Example :
%   suppose initialisation
%   PTS  = rand(20, 3);
%   ROT1 = rotationOx(pi/3);
%   ROT2 = rotationOx(pi/4);
%   ROT3 = rotationOx(pi/5);
%   ROTS = composeTransforms3d(ROT1, ROT2, ROT3);
%   Then :
%   PTS2 = transformPoint3d(PTS, ROTS);
%   will give the same result as:
%   PTS3 = transformPoint3d(transformPoint3d(transformPoint3d(PTS, ...
%       ROT1), ROT2), ROT3);
%
%   See also :
%   transformPoint3d, translation3d, rotationOx, rotationOy, rotationOz
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 29/29/2006.
%

trans = varargin{nargin};
for i=length(varargin)-1:-1:1
    trans = trans*varargin{i};
end
