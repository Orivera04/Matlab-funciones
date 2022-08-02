function out=istableexportable(obj)
%ISTABLEEXPORTABLE 
%
%  RET= ISTABLEEXPORTABLE(NODE) returns true if the node supports exporting
%  to a calibration format (ie via cgcaloutput).

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:37:53 $

if isempty(obj.Tables)
   out = false;
else
   out = true;
end