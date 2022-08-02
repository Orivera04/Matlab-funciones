function V = setpoint(V,newsetpt)
%SETPOINT
%
% V = setpoint(V)
%   Forces the cgvariable to take up it's setpoint
%
% V = setpoint(V,newsetpt)
%   Assign a new setpoint and force the cgvalue to take up it's setpoint

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:17:02 $

if nargin ==2
    if isa(newsetpt,'double')
        V = setnomvalue(V, newsetpt(1));
    end
end
V = setvalue(V, getnomvalue(V));