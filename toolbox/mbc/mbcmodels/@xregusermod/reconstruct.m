function p=reconstruct(U,Yrf,dG,rfuser);
% xregusermod/RFVALS evaluate response features and dG

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:36 $

[p]= feval(U.funcName,U,'reconstruct',Yrf,dG,rfuser);
if isempty(p)
   % default is linear response features
   p= Yrf/dG';
end
