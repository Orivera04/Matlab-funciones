function c = getcharacteristic(obj)
% GETCHARACTERISTIC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 07:13:53 $

c.name = getname(obj);
data = get(obj,'values'); 
BP = get(obj,'breakpoints');
c.X.values = BP;
c.Y.values = data;

