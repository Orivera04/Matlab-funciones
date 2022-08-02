function x = myMatrixAD(x, varargin)
% /*
%  * myMatrixAD and myA2D - Automatic Differentiation of 1st and 2nd Derivative
%  * Copyright (C) 2006 Martin Fink. (martinfink "at" gmx.at)
%  *
%  * This library is free software; you can redistribute it and/or
%  * modify it under the terms of the GNU General Public License
%  * as published by the Free Software Foundation; either version 2.1
%  * of the License, or (at your option) any later version.
%  *
%  * This library is distributed in the hope that it will be useful,
%  * but WITHOUT ANY WARRANTY; without even the implied warranty of
%  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
%  * General Public License for more details.
%  *
%  * You should have received a copy of the GNU General Public License
%  * along with this library; if not, visit
%  * http://www.gnu.org/licenses/gpl.html or write to the Free Software
%  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
%  */

if (isa(x, 'myMatrixAD'))
    return;
end

sx = size(x);
if (length(sx)>2)
    error('myMatrixAD allows maximal 2D-matrices.');
end

struct_x.nVariables = sx(1)*sx(2);
struct_x.values = x;
if (nargin < 2)
    struct_x.derivatives(:,1,:) = eye(struct_x.nVariables);
    struct_x.derivatives = reshape(struct_x.derivatives,sx(1),sx(2),sx(1)*sx(2));
else
    struct_x.derivatives = varargin{1};
    struct_x.nVariables = varargin{2};
end
x = class(struct_x, 'myMatrixAD');
