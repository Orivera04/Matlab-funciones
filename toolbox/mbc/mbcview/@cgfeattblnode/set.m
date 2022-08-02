function node = set(node,varargin)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:24:02 $

for i = 1:2:length(varargin)
    property = varargin{i};
    newvalue = varargin{i+1};
    switch lower(property)
    case 'sfdata'
        node.SFData = newvalue;
    otherwise
        node.cgtablenode = set(node.cgtablenode,property,newvalue);
    end
end

return