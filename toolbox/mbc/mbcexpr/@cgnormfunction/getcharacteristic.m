function c = getcharacteristic(obj)
% GETCHARACTERISTIC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.8.2.3 $  $Date: 2004/02/09 07:14:43 $

c.name = getname(obj);
c.Y.values = get(obj,'values');
xNormaliser = get(obj,'x');
BP = get(obj,'breakpoints');
try
    c.X.values = xNormaliser.invert(BP);
catch
    c.X.values = BP;
end

