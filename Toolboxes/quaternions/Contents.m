% Quaternions Toolbox
% Version 1.2.2 (JASP) 20-Jan-2002
% ==================
% Copyright, 2000-02 Jay A. St. Pierre (Jay.St.Pierre at Colorado.EDU)
% This Toolbox comes with ABSOLUTELY NO WARRANTY.  This is free software,
% and you are welcome to redistribute it under certain conditions.  See
% the file COPYING that came with the software for more details.
% ==================
%
% For purposes of these tools, a quaternion, q, is just a four element
% vector where q(1:3) is the "imaginary" or "vector" portion of the
% hypercomplex number, and q(4) is the "real" or "scalar" portion.
% Consequently, if q represents a rotation, then:
%
%   q(1) = v1*sin(phi/2)
%   q(2) = v2*sin(phi/2)
%   q(3) = v3*sin(phi/2)
%   q(4) =    cos(phi/2)
%
% where phi is the amount of rotation about the unit vector [v1 v2 v3].
%
% All tools are vectorized, so "vectors" of quaternions (4xN or Nx4
% matrices) can be handled as well.  Since it is most common to work with
% normalized quaternions (also referred to as "unit quaternions" and
% "versors"), if a set of 4 quaternions, i.e., a 4x4 matrix, is input, the
% tools will attempt to determine the shape of the component quaternions
% (4x1 or 1x4) based on whether the rows or columns are normalized.
%
% Of course, some of the tools, like QDECOMP, only make sense for normalized
% quaternions, and thus those tools enforce normality via QNORM.
%
%   isq     - determines whether or not input is a quaternion
%   isnormq - determines whether or not input is a normalized quaternion
%
%   qconj   - quaternion conjugate
%   qnorm   - normalize quaternion
%   qmult   - multiply quaternions
%
%   qdecomp - decompose quaternion into unit vector and rotation angle
%   qvxform - quaternion/vector transform
%   qvrot   - quaternion/vector rotation
%
%   q2dcm   - quaternion to direction cosine matrix
%   dcm2q   - direction cosine matrix to quaternion
%
% See also QLIB, the Quaternion block library for Simulink.


% Package: $Name: quaternions-1_2_2 $
% File: $Revision: 1.15 $
% $Date: 2002/01/21 06:50:15 $


% Quaternion Toolbox for MATLAB (versions 5.x and greater)
% Copyright (C) 2000-02, Jay A. St. Pierre.
%
% This package is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


% To contact the author:
%
% E-mail:     Jay.St.Pierre at Colorado.EDU
%
% Snail Mail: 3178 Cripple Creek Trail
%             Boulder, CO  80305
