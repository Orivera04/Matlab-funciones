function bigpop(figNumber)
%BIGPOP	Enlarges uicontrol popup menus for use with PCs.
%	BIGPOP(figNumber) is used to increase the size of popup menus
%	on the PC, since the popup menu works slightly differently there.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

compType=computer;
if compType(1:2)=='PC',

    if nargin<1, figNumber=gcf; end

    hndlList=get(figNumber,'Children');
    for count=1:length(hndlList),
    	if strcmp(get(hndlList(count),'Type'),'uicontrol'),
	    if strcmp(get(hndlList(count),'Style'),'popupmenu'),
	    	popupPos=get(hndlList(count),'Position');
	   	popupHt=popupPos(4);
	    	popupPos(4)=4*popupHt;
	    	set(hndlList(count),'Position',popupPos);
	    end
        end
    end

end
