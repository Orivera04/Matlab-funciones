function h = cghelpbutton(fig,code,varargin)
%CGHELPBUTTON Add a help button to a figure
%
%  H = CGHELPBUTTON(FIG,CODE) adds a MBC help button to the figure fig,
%  pointing to help topic CODE.
%
%  H = CGHELPBUTTON(FIG,CODE,props,vals) passes on the props and vals to
%  the help button on creation.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/04/04 03:36:47 $

h=uicontrol('parent',fig,...
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
    cghelptool(helpTag, hFig);
else
    cghelptool(helpTag);
end