function out = get(node,property)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:23:58 $

switch lower(property)
case 'sfdata'
    out = node.SFData;
otherwise
    out = get(node.cgtablenode,property);
end
return
