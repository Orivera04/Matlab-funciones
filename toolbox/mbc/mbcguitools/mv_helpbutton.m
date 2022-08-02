function h = mv_helpbutton(fig,code,varargin)
%MV_HELPBUTTON Add a help button to a figure
%
%  H = MV_HELPBUTTON(FIG,CODE) adds a Model-Based Calibration Toolbox help
%  button to the figure fig, pointing to help topic CODE.
%
%  H = MV_HELPBUTTON(FIG,CODE,props,vals) passes on the props and vals
%  to the help button on creation.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/04/04 03:29:28 $

if fig==0
    % dispatcher
    i_helpCB([],[],code);
else
    % create button
    h = i_createbutton(fig,code,varargin{:});
end



function h = i_createbutton(fig,code,varargin)
h = uicontrol('parent',fig,...
    'style','pushbutton',...
    'position',[0 0 65 25],...
    'string','Help',...
    'callback',{@i_helpCB,code},...
    'interruptible','off',...
    'tag','HelpButton',...
    varargin{:});



function i_helpCB(src, evt, helpTag)
hFig = mbcfindfigure(src);
if ~isempty(hFig) && strcmp(get(hFig, 'WindowStyle'), 'modal');
    mv_helptool(helpTag, hFig);
else
    mv_helptool(helpTag);
end
