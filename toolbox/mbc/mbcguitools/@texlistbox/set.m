function varargout=set(varargin)
%TEXLISTBOX/SET   Set interface for the TexListBox object
%   Classic set function for the TexListBox object
%   properties are:
%
%      Userdata
%      String    :  Cell array of strings
%      Min       :  If Max-Min>1 then multi-select is enabled,
%      Max       :   otherwise single selection is performed.
%      ListBoxTop:  Index of top string to display.
%      Callback  :  Callback string
%      Value     :  Vector of selected indices
%      
%   All other properties are passed through to the ListCtrl object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:20:38 $

% Created 4/10/00


objfind=1;
while objfind
   if strcmpi(class(varargin{objfind}),'TexListBox')
      obj(objfind)=varargin(objfind);
      objfind=objfind+1;
   else
      varargin=varargin(objfind:end);
      objfind=0;
   end   
end

if ~iscell(obj)
   obj={obj};
end

for k=1:length(obj)
   wrkobj=obj{k};
   % loop over varargin
   for n=1:2:(nargin-2)
      value=varargin{n+1};
      switch lower(varargin{n})
      case 'string'
         i_setstring(wrkobj,varargin{n+1});
      case 'min'
         ud=get(wrkobj.xreglistctrl,'userdata');
         ud.min=varargin{n+1};
         ud.selmode=((ud.max-ud.min)>1);
         set(wrkobj.xreglistctrl,'userdata',ud);
      case 'max'
         ud=get(wrkobj.xreglistctrl,'userdata');
         ud.max=varargin{n+1};
         ud.selmode=((ud.max-ud.min)>1);
         set(wrkobj.xreglistctrl,'userdata',ud);
      case 'listboxtop'
         set(wrkobj.xreglistctrl,'top',varargin{n+1});
      case 'value'
         i_setvalue(wrkobj,varargin{n+1});   
      case 'callback'
         if ischar(varargin{n+1})
            ud=get(wrkobj.xreglistctrl,'userdata');
            ud.callback=varargin{n+1};
            set(wrkobj.xreglistctrl,'userdata',ud);
         end
      case 'parent'
         if ishandle(varargin{n+1})
            ud=get(wrkobj.xreglistctrl,'userdata');
            ud.parent=varargin{n+1};
            set(wrkobj.xreglistctrl,'userdata',ud);
            set(wrkobj.xreglistctrl,'parent',varargin{n+1});
         end
      case 'enable'
         i_setenable(wrkobj,varargin{n+1});
      case 'fontsize'
         ud=get(wrkobj.xreglistctrl,'userdata');
         ud.fonts.fontsize=varargin{n+1};
         set(wrkobj.xreglistctrl,'userdata',ud);
         i_setel(wrkobj,'fontsize',varargin{n+1});
      case 'fontname'
         ud=get(wrkobj.xreglistctrl,'userdata');
         ud.fonts.fontname=varargin{n+1};
         set(wrkobj.xreglistctrl,'userdata',ud);
         i_setel(wrkobj,'fontname',varargin{n+1});
      otherwise
         set(wrkobj.xreglistctrl,varargin{n},varargin{n+1});
      end
   end
   obj{k}=wrkobj;
end
% resurrect outputs
nargout=length(obj);
varargout=obj;
return




function i_setstring(obj,str)
ud=get(obj.xreglistctrl,'userdata');
% create axestext objects.
el=get(obj.xreglistctrl,'elements');

if ~iscell(str)
   str={str};
end
N=length(str);
if length(el)~=N
   % create new ones
   el=cell(N,1);
   vis=get(obj.xreglistctrl,'visible');
   for n=1:N
      el{n}=seltext(ud.parent,'visible',vis,'string',str{n},...
         'fontsize',ud.fonts.fontsize,'fontname',ud.fonts.fontname,...
         'interruptible','off','callback','cbselect(%OBJECT%,%VALUE%);',...
         'verticalalignment','middle');         
   end
   set(obj.xreglistctrl,'elements',el);
   ud.value(ud.value>N)=[];
   if isempty(ud.value)
      ud.value=1;
   end
   % perform "selected" highlighting
   i_sel(el,ud.value)
else
   for n=1:N
      set(el{n},'string',str{n});
   end
end
ud.string=str;

set(obj.xreglistctrl,'userdata',ud);
return




function i_setvalue(obj,val)
ud=get(obj.xreglistctrl,'userdata');
el=get(obj.xreglistctrl,'elements');
N=length(el);

% remove selection >N
val=val(val<=N);
if ~ud.selmode & isempty(val)
   return
end
if ~ud.selmode
   val=val(1);
end

% select correct items
i_unsel(el,setxor(1:N,val));
i_sel(el,val);

if ~isempty(val)
   ud.multiclickind=val(end);
end
ud.value=val;
set(obj.xreglistctrl,'userdata',ud);
return



function i_unsel(el,val)
% unselect elements
if nargin<2
   val=1:length(el);
end
for n=val
   set(el{n},'selected','off');
end
return


function i_sel(el,val)
% select elements
if nargin<2
   val=1:length(el);
end
for n=val
   set(el{n},'selected','on');
end
return   



function i_setenable(obj,val)
el=get(obj.xreglistctrl,'elements');
numel=length(el);
if ischar(val)
   val=repmat({val},numel,1);
else
   if length(val)~=numel
      error('Enable settings length does not match number of strings.');
   end
end

% loop over seltext objects and set enable status.
for n=1:numel
   set(el{n},'enable',val{n});   
end
return



function i_setel(obj,param,value);
% loop over all contained test items and set the parameter
el=get(obj.xreglistctrl,'elements');
for n=1:length(el)
   set(el{n},param,value);
end
return




