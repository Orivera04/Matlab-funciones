function out = get(node,property)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:29:43 $

switch lower(property)
case 'data'
    out = node.Data;
case 'managers'
    out = node.Managers;
case 'inversiondata'
    out = node.InversionData;
case 'sfdata'
    out = [];
end
return
