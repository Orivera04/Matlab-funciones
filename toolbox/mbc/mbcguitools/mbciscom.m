function out = mbciscom(obj)
%MBCISCOM  Check if objects is a com object
%
%  MBCISCOM(OBJ) returns true if OBJ is a com object or interface
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 07:33:20 $

out = false;
s = class(obj);
if length(s)>=4
   out = strcmp(s(1:4),'COM.');
elseif length(s)>=10
   out = strcmp(s(1:10),'Interface.');
end