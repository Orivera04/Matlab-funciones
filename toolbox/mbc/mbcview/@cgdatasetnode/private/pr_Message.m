function pr_Message(d,mess,uimenu);
%PR_MESSAGE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:22:27 $

if nargin<3, uimenu = 0; end

cur_page = get(d.Handles.TopCard,'currentcard');
if isnumeric(mess)
    set(d.Handles.TopCard,'currentcard',mess);
else
    set(d.Handles.Message,'string',mess);
    f = strmatch('message',{d.ViewInfo.ID},'exact');
    if length(f)==1
        set(d.Handles.TopCard,'currentcard',d.ViewInfo(f).card);
        set(d.ViewInfo(f).layout,'uicontextmenu',uimenu);
        drawnow;
    else
        error(mess);
    end
end    
