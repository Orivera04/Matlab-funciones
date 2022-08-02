function x = myA2D(x, varargin)
% /*
%  * myAD and myA2D - Automatic Differentiation of 1st and 2nd Derivative
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

if (isa(x, 'myA2D'))
    return;
end

struct_x.values = x(:);
if (nargin < 3)
    n = length(x);
    struct_x.derivatives = eye(n);
    struct_x.secderiv = zeros(n,n,n);
else
    struct_x.derivatives = varargin{1};
    struct_x.secderiv = varargin{2};
end
x = class(struct_x, 'myA2D');
