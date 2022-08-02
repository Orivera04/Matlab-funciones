function pr_initlines(gr)
% This is a private graph2d function used to initialise correct
%  number of lines and patches

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:23 $


ud = get(gr.axes,'userdata');
data = get(gr.xtext,'userdata');
ydata = get(gr.ytext,'userdata');

switch lower(ud.type)
case 'single'
    no_l = 1;
    no_p = 1;
    fillsize = [1 1];
case 'multi'
    no_p = size(ydata,2);
    % Create an extra line for Y=X line
    no_l = no_p + 1;
    fillsize = [size(ydata,2) size(data,2)];
case 'multinoerror'
    no_p = size(ydata,2);
    no_l = no_p;
    fillsize = [size(ydata,2) size(data,2)];
case 'table'
    no_p = 1;
    no_l = 6;
    fillsize = [1 1];
end
% Check number of marker types 
if length(ud.marker)>=no_l
    lmarker=ud.marker(1:no_l);
elseif length(ud.marker)<no_l
    lmarker=cellstr(repmat('o',no_l,1));
    lmarker(1:length(ud.marker))=ud.marker;
end
if length(ud.marker)>=no_p
    pmarker=ud.marker(1:no_p);
elseif length(ud.marker)<no_p
    pmarker=cellstr(repmat('o',no_p,1));
    pmarker(1:length(ud.marker))=ud.marker;
end

% Check number of marker colors for lines
if length(ud.markercolor)>=no_l
    lcol=ud.markercolor(1:no_l);
elseif length(ud.markercolor)==1
    lcol=num2cell(repmat(ud.markercolor{1},no_l,1),2);
elseif length(ud.markercolor)<no_l
    lcol=num2cell(hsv(no_l),2);
    if ~isempty(ud.markercolor)
        lcol(1:length(ud.markercolor))=ud.markercolor;
    end
end
ud.checkedmcolor = lcol;

% Check fill mask
if all(size(ud.fillmask)==fillsize)
    fm = ud.fillmask;
else
    fm = repmat(1,fillsize);
end
ud.checkedfillmask = fm;

% make some new lines if needed
if length(ud.lines)>no_l
    delete(ud.lines(no_l+1:end));
    ud.lines = ud.lines(1:no_l);
else
    for i = length(ud.lines)+1:no_l
        h = xregGui.line('parent',gr.axes,'xdata',[],'ydata',[],...
            'linestyle','none',...
            'visible','off',...
            'uicontextmenu',ud.contextmenu,...
            'markersize',ud.markersize);
        ud.lines = [ud.lines h];
    end
end

% and some new patches
if length(ud.patches)>no_p
    delete(ud.patches(no_p+1:end));
    ud.patches = ud.patches(1:no_p);
else
    for i = length(ud.patches)+1:no_p
        h = xregGui.patch('parent',gr.axes,'xdata',[],'ydata',[],'cdata',[],...
            'edgecolor','none','facecolor','none',...
            'markerfacecolor','flat','markeredgecolor','flat',...
            'visible','off',...
            'uicontextmenu',ud.contextmenu,...
            'markersize',ud.markersize);
        ud.patches = [ud.patches h];
    end
end

% Insert marker types
%  Cannot set colors here - need to know if filled or not.
set(ud.lines,{'marker'},lmarker(:),'linestyle','none');
set(ud.patches,{'marker'},pmarker(:));

set(gr.axes,'userdata',ud);
