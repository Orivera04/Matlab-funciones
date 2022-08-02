function c = getcharacteristic(obj)
%GETCHARACTERISTIC Return calibration data
%
%  C = GETCHARACTERISTIC(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:08:14 $

c.name = getname(obj);
c.X.values = getvalue(obj);
