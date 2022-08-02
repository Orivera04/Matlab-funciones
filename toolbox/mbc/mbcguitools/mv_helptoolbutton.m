function h = mv_helptoolbutton(fig,code,varargin)
%MV_HELPTOOLBUTTON Add a help toolbar button to a figure
%
%  H = MV_HELPTOOLBUTTON(TB,CODE) adds a Model-Based Calibration Toolbox
%  toolbar button to the toolbar TB, pointing to help topic CODE.
%
%  H = MV_HELPTOOLBUTTON(TB,CODE,props,vals) passes on the props and vals
%  to the help button on creation.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.3 $  $Date: 2004/04/04 03:29:31 $

if isnumeric(fig) && fig==0
    % dispatcher
    i_helpCB([],[],code);
else
    % create button
    h = i_createbutton(fig,code,varargin{:});
end


function h = i_createbutton(fig,code,varargin)
im = xregresload('help.bmp','bmp');
if isa(fig, 'xregtoolbarlayout') || isa(handle(fig), 'xregGui.uitoolbar')
    % MBC toolbar parent
    h = xregGui.uipushtool(fig,...
        'cdata',im,...
        'clickedcallback',{@i_helpCB,code},...
        'interruptible','off',...
        'tag','HelpButton',...
        'separator','on',...
        'tooltip','Help',...
        'transparentcolor',[0 255 0],...
        varargin{:});
elseif isa(handle(fig), 'hg.uitoolbar')
    % HG parent
    sc = xregGui.SystemColors;
    h = uipushtool(fig,...
        'cdata',replacecolor(im,[0 255 0],double(sc.CTRL_BACK)),...
        'clickedcallback',{@i_helpCB,code},...
        'interruptible','off',...
        'tag','HelpButton',...
        'separator','on',...
        'tooltip','Help',...
        varargin{:});
else
    % Update an existing button
    h = fig;
    set(h, 'clickedcallback',{@i_helpCB,code},...
        varargin{:});
end


function i_helpCB(src, evt, helpTag)
hFig = mbcfindfigure(src);
if ~isempty(hFig) && strcmp(get(hFig, 'WindowStyle'), 'modal');
    mv_helptool(helpTag, hFig);
else
    mv_helptool(helpTag);
end
