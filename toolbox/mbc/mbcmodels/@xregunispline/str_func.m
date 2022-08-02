function fx=str_func(Model,TeX)
%STR_FUNC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:37 $

m3= Model.mv3xspline;
set(m3,'code',get(Model,'code'));
fx= str_func(m3,TeX);