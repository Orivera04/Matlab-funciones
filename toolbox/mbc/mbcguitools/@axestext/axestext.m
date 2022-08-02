function obj=axestext(varargin)
% AXESTEXT  Wrapper object for axes text object
%
%  AXESTEXT provides a wrapper class around axes text objects
%  and allows them to be used in layouts
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:17:50 $


if nargin>0 & ishandle(varargin{1}) & strcmp(get(varargin{1},'type'),'figure')
   figh=varargin{1};
   varargin(1)=[];
else
   figh=gcf;
end

pos=get(0,'defaultuicontrolposition');

fa=xregGui.figureaxes;
obj.version=1;
ud.position=pos;
ud.string='';
ud.stringext=[];
ud.clipping=0;
ud.userdata=[];
ud.altstring='';
ud.alttringext=[];
obj.wrappedobject=xregtext('parent',getaxes(fa,figh),'visible','off','clipping','off',...
   'horizontalalignment','left','verticalalignment','bottom','position',[pos(1) pos(2) 0],...
   'userdata',ud,'units','pixels');

obj=class(obj,'axestext');

if ~any(strcmp('visible',lower(varargin(1:2:end))))
   set(obj.wrappedobject,'visible','on');
end
if length(varargin)
   obj=set(obj,varargin{:});
end
return
