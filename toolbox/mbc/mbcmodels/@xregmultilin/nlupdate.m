function m= nlupdate(m,p);
% xreglinear/NLUPDATE update of nonlinear parameters

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:42 $

m2= nlupdate(get(m,'currentmodel'),p);
set(m,'currentmodel',m2);