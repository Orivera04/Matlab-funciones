function out = get(node,property)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:25:32 $

switch lower(property)
case 'data'
    out = node.Data;
case 'sfdata'
    out = node.SFData;
case 'managers'
    out = node.Managers;
end
return
