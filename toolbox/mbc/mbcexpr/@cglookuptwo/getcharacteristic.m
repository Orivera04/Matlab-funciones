function c = getcharacteristic(obj)
% GETCHARACTERISTIC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.6.2.3 $  $Date: 2004/02/09 07:11:37 $

c.name = getname(obj);
c.Z.values = get(obj,'values');
xNormaliser = get(obj,'x');
yNormaliser = get(obj,'y');
S = size(c.Z.values);
try
    c.X.values = xNormaliser.invert(0:S(2)-1);
catch
    c.X.values = 0:S(2)-1;
end
try
    c.Y.values = yNormaliser.invert(0:S(1)-1);
catch
    c.Y.values = 0:S(1)-1;
end