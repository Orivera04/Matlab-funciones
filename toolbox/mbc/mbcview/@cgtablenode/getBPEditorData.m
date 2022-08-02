function [Data,SFData] = getBPEditorData(node)
%GETBPEDITORDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:29:44 $

ch = children(node);
if ~isempty(ch)
    Data = ch(1).get('data');
    SFData = ch(1).get('sfdata');
else
    Data = [];
    SFData = [];
end 
return
