function h = cghelptoolbutton(fig,code,varargin)
% CGHELPTOOLBUTTON   Add a help toolbar button to a figure
%
%  H = CGHELPTOOLBUTTON(TB,CODE) adds a MBC toolbar button to the toolbar
%  TB, pointing to help topic CODE.
%
%  H = CGHELPTOOLBUTTON(TB,CODE,props,vals) passes on the props and vals
%  to the help button on creation.
%
%  H = CGHELPTOOLBUTTON(BUT, CODE, props, vals) updates the settings for
%  the given button, BUT.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/04/04 03:36:50 $

if isa(fig, 'xregtoolbarlayout') || isa(handle(fig), 'xregGui.uitoolbar')
    % MBC toolbar parent
    ic = cgresload('helpicon.bmp','bmp');
    h = xregGui.uipushtool(fig,...
        'cdata',ic,...
        'clickedcallback',{@i_helpCB,code},...
        'interruptible','off',...
        'tag','HelpButton',...
        'separator','on',...
        'tooltip','Help',...
        'transparentcolor',[0 255 0],...
        varargin{:});
elseif isa(handle(fig), 'hg.uitoolbar')
    % HG toolbar parent
    im = cgresload('helpicon.bmp','bmp');
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
    cghelptool(helpTag, hFig);
else
    cghelptool(helpTag);
end