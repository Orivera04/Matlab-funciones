function c = getcharacteristic(obj)
% GETCHARACTERISTIC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 07:12:21 $

c.name = getname(obj);
c.Y.values = get(obj,'values');
xNormaliser = get(obj,'x');
BP = get(obj,'breakpoints');
c.X.values = BP;

