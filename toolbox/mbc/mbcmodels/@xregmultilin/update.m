function m= update(m,c);
% xreglinear/UPDATE Update coefficients
%
% m= update(m,c);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:06 $

m2= update(get(m,'currentmodel'),c);
set(m,'currentmodel',m2);