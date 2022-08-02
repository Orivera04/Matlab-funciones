function obj = xregtextinput(varargin)
%%xregtextinput Constructor for the text control/input object.
%%   Usage:
%%   C=xregtextinput
%%   C=xregtextinput(FIG)
%%   C=xregtextinput('Property1',Value1,...)
%%   C=xregtextinput(FIG,'Property1',Value1,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:01 $

obj.hnd = [];

if nargin>0 & ishandle(varargin{1}) & strcmp(get(varargin{1},'type'),'figure')
   fh=varargin{1};
   varargin(1)=[];
else
   fh=gcf;
end

%% default position; set called at end if position input
pos = [10 10 100 40];

bgc = get(fh,'color'); % Change from gcf to fh to stop rogue figures being spawned when Handle visibility of fh is off.
uiH = xreguicontrol('style','text',...
   'visible','off',...
   'parent',fh,...
   'position',pos,...
   'string','',...
   'horizontalAlignment','left',...
   'backgroundcolor',bgc);

obj.hnd=uiH;

obj = class(obj,'xregtextinput');

if length(varargin)
   obj=set(obj,varargin{:});
end
