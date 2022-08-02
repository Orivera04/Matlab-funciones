function node = set(node,varargin)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:29:55 $

for i = 1:2:length(varargin)
    property = varargin{i};
    newvalue = varargin{i+1};
    switch lower(property)
    case 'bpdata'
        ch = children(node);
        for i = 1:length(ch);
            ch(i).info = ch(i).set('data',newvalue);
        end
    case 'bpsfdata'
        ch = children(node);
        for i = 1:length(ch);
            ch(i).info = ch(i).set('sfdata',newvalue);
        end
    case 'bpmanagers'
        ch = children(node);
        for i = 1:length(ch);
            ch(i).info = ch(i).set('managers',newvalue);
        end
    case 'data'
        node.Data = newvalue;
    case 'inversiondata'
        node.InversionData = newvalue;
    case 'managers'
        node.Managers = newvalue;
    end
end

return