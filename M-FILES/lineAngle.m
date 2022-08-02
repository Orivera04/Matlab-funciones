function theta = lineAngle(varargin)
%LINEANGLE return angle between lines
%
%   a = LINEANGLE(line) return the angle between horizontal, right-axis 
%   and the given line. Angle is fiven in radians, between 0 and 2*pi,
%   in counter-clockwise direction.
%
%   a = LINEANGLE(line1, line2) return the directed angle between the
%   two lines. Angle is given in radians between 0 and 2*pi.
%
%   see createLine for more details on line representation.
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 31/10/2003.
%

%   HISTORY :
%   19/02/2004 : added support for multiple lines.

nargs = length(varargin);
if nargs == 1
    % one line
    line = varargin{1};
    theta = mod(atan2(line(:,4), line(:,3)) + 2*pi, 2*pi);
elseif nargs==2
    % two lines
    theta1 = lineAngle(varargin{1});
    theta2 = lineAngle(varargin{2});
    theta = mod(theta2-theta1+2*pi, 2*pi);
end
