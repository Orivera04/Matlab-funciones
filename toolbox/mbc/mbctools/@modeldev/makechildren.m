function child_MD= makechildren(MD,OpenDialog)
%MAKECHILDREN Make children for this modeldev node

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:34 $

if nargin < 2
    OpenDialog=0;
end

m= MD.Model;
p=address(MD);
% model dpt children
child_MD= modeldev(m,p,OpenDialog);

% children info changed
MD= p.info;
s= status(MD);
if s==2 && numChildren(MD)==1
    MD.BestModel= child_MD;
    child_MD.status(s);
    pointer(MD);
end
