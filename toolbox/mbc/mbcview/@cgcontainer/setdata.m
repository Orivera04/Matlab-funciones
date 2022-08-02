function obj=setdata(obj,d);
%SETDATA  set the data object held in the container
%
%  D=SETDATA(OBJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:22:02 $

obj.data=d;
pointer(obj);