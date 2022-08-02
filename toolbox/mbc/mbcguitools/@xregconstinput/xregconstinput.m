function obj = xregconstinput(varargin)
%% XREGCONSTINPUT Constructor for the constant control/input object.
%%   Usage:
%%   C=XREGCONSTINPUT
%%   C=XREGCONSTINPUT(FIG)
%%   C=XREGCONSTINPUT('Property1',Value1,...)
%%   C=XREGCONSTINPUT(FIG,'Property1',Value1,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:54 $


%% copy of object in ud of edit
%% other info in ud of text

obj.text = [];
obj.edit = [];
ud.min = -Inf;
ud.max = Inf;
ud.value = 0;
ud.callback = '';
ud.UserData = [];

%Addition by djo. I'm putting in a flag which allows string data to be input.
%
%Change the char status using the set(obj , 'charstatus' , {'on'|'off'});
ud.CharStatus = 0;

if nargin>0 & ishandle(varargin{1})...
       & strcmp(get(varargin{1},'type'),'figure')
   fh=varargin{1};
   varargin(1)=[];
else
   fh=gcf;
end

%% default position; set called at end if position input
pos = [10 10 100 40];
bgc = get(fh,'color'); % Change from gcf to fh to stop rogue figures being spawned when Handle visibility of fh is off.

%% 10 <= edit <= 50
editLength = min(max(pos(3)/2,10),50);
editPos = [pos(1)+pos(3)-editLength pos(2) editLength pos(4)];
edit = xreguicontrol('style','edit',...
   'visible','off',...
   'parent',fh,...
   'position',editPos,...
   'backgroundcolor',[1 1 1],...
   'string','',...
   'horizontalAlignment','left');

txtLength = pos(3)-editLength;
txtPos = pos; txtPos(3) = txtLength;
text = xreguicontrol('style','text',...
   'visible','off',...
   'parent',fh,...
   'position',txtPos,...
   'string','',...
   'horizontalAlignment','left',...
   'backgroundcolor',bgc);

set(text,'userdata',ud);

obj.text = text;
obj.edit = edit;
%% class constructor
obj = class(obj,'xregconstinput');

builtin('set',edit,...
   'callback',['callback(get(' sprintf('%20.15f',edit) ',''userdata''));']);
builtin('set',edit,'userdata',obj);

if length(varargin)
   obj=set(obj,varargin{:});
end

charstatus=lower(get(obj,'charstatus'));
val = get(obj,'value');
if strcmp(charstatus,'off') & isempty(val)
	set(obj,'value',0);
end