function m= update(m,c);
% HYBRIDRBF/UPDATE Update coefficients
%
% m= update(m,c);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:48:29 $

m.xreglinear = update(m.xreglinear,c);
numlm = size(m.linearmodpart,1);
m.linearmodpart = update(m.linearmodpart,c(1:numlm));
m.rbfpart = update(m.rbfpart,c(numlm+1:end));