function d = pr_EnableToolbar(d)
%pr_EnableToolbar(d)
%  Check empty status of dataset and enable appropriate views

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:22:23 $

en0 = ~d.pD.isempty && (d.pD.get('numpoints')>0);

defaultview = false;
d.Handles.ViewToolbar.setRedraw(false);
for i = 1:length(d.ViewInfo)
    page = d.ViewInfo(i);
    if ~isempty(page.button) 
        if ~isempty(page.enablestatus)
            if isnumeric(page.enablestatus)
                en = page.enablestatus;
            else
                en = feval(page.enablestatus,d.pD.info);
            end
        else
            en = en0;
        end
        if en
            set(d.Handles.ViewToggle(page.button),'enable','on');
        else
            set(d.Handles.ViewToggle(page.button),'enable','off');
            if i==d.currentviewinfo & ~page.dialog
                % problem - current view is not allowed.
                defaultview = true;
            end
        end
    end
    if ~isempty(page.menuitem)
        if ~isempty(page.enablestatus)
            if isnumeric(page.enablestatus)
                en = page.enablestatus;
            else
                en = feval(page.enablestatus,d.pD.info);
            end
        else
            en = en0;
        end
        if en
            set(page.menuitem,'enable','on');
        else
            set(page.menuitem,'enable','off');
        end
    end
end

if defaultview
    d = pr_ChangeView(d,'factors','setup');
end
d.Handles.ViewToolbar.setRedraw(true);
d.Handles.ViewToolbar.drawToolBar;
            