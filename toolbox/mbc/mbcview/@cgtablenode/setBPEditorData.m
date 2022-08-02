function node = setBPEditorData(node,Data,SFData)
%SETBPEDITORDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:29:56 $

ch = children(node);

for i = 1:length(ch)
    ch(i).info = ch(i).setBPEditorData(Data,SFData);
end

return