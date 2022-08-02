function rl=roller(varargin)
%ROLLER   Constructor function for the roller object
%   ROLLER is the creator function for the 'roller' guitool
%   Usage:
%   R=ROLLER
%   R=ROLLER(FIG)
%   R=ROLLER('Property1',Value1,...)
%   R=ROLLER(FIG,'Property1',Value1,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:26 $


if nargin>0 & isnumeric(varargin{1})
   figh=varargin{1};
   varargin(1)=[];
else
   figh=gcf;
end

% data:
% visible setting (0/1) in rl.frame1
% value in rl.frame2
% object in rl.text1
% callback fields in text2

% set up with default uicontrol stuff
pos=get(0,'defaultuicontrolposition');
rl.frame1=uicontrol('style','frame',...
   'parent',figh,...
   'visible','off',...
   'userdata',1,...
   'enable','inactive');
rl.text1=uicontrol('style','text',...
   'parent',figh,...
   'visible','off',...
   'position',[pos(1)+1 pos(2)+1 pos(3)-2 pos(4)-2],...
   'enable','inactive',...
   'interruptible','off');
builtin('set',rl.text1,'buttondownfcn',['rollcb(get(' sprintf('%20.15f',rl.text1) ',''userdata''))']);
rl.frame2=uicontrol('style','frame',...
   'parent',figh,...
   'visible','off',...
   'userdata',0,...
   'enable','inactive');
ud.callback='';
ud.cbactive=0;
rl.text2=uicontrol('style','text',...
   'parent',figh,...
   'visible','off',...
   'position',[pos(1)+1 pos(2)+1 pos(3)-2 pos(4)-2],...
   'buttondownfcn',['rollcb(get(' sprintf('%20.15f',rl.text1) ',''userdata''))'],...
   'enable','inactive',...
   'interruptible','off',...
   'userdata',ud);

rl=class(rl,'roller');
builtin('set',rl.text1,'userdata',rl);

if ~any(strcmp('visible',lower(varargin(1:2:end))))
   set([rl.frame1;rl.text1],'visible','on');
end
% set extra props if specified
if length(varargin)
   rl=set(rl,varargin{:});
end