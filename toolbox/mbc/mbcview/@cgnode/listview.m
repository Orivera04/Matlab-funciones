function  varargout=listview(T,Action,SI,varargin)
%LISTVIEW  ListView actions interface
%
% listview(T,action,SubItem,varargin)
%
%  Actions and arguments are:
%
%     Clear:  {List}
%     Remove: {List}
%     Add:    {List,ImageList manager, TypeFilter}
%     Select: {List}
%     LateSelect: {List}
%     Refresh: {List,ImageList manager, TypeFilter}
%     Current: {List}
%     Currentsub: {List}
%     Update: {List,ImageList manager}

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.7.2.2 $  $Date: 2004/02/09 08:25:08 $


if nargout==1
   varargout{1}=[];
end
switch lower(Action)
case 'clear'
   i_Clear(T,varargin{:});
case 'remove'
   i_Remove(T,SI,varargin{:});
case 'select'
   i_Select(T,SI,varargin{:});
case 'lateselect'
	i_LateSelect(T,SI,varargin{:});
case 'refresh'
   i_Refresh(T,varargin{:});
case 'current'
   varargout{1}= i_Current(T,varargin{:});
case 'currentsub'
   varargout{1}= i_CurrentSub(T,varargin{:});   
case 'update'
	i_Update(T,SI,varargin{:});
end


function i_Refresh(T,h,IL,tpfilter);
if nargin<5
   MaxLvl= Inf;
end
r=root(T);
try
   if h.ListItems.Count
      key=h.SelectedItem.key;
   else
      key=0;
   end
catch
   key=0;
end
i_Clear(T,h)
buildlist(r.info,h,IL,tpfilter);
if key
   h.SafeSelect(key);
end


function i_Clear(T,h);
h.ListItems.Clear;

function i_Remove(T,SI,h);
key= genkey(T,SI);
h.SafeRemove(key);

function i_Select(T,SI,h)
key= genkey(T,SI);
h.SafeSelect(key);

function i_LateSelect(T,SI,h)
key= genkey(T,SI);
nodes= h.listitems;
Item= nodes.Item(key);
set(h,'LateSelectedItem',Item);

function i_Update(T,SI,h,IL)
nodes= get(h,'listitems');
key= genkey(T,SI);
item= nodes.Item(key);
ic=bmp2ind(IL,iconfile(T));
set(item,'smallicon',ic);
set(item,'text',name(T));

% update the columns of information
[nds,cheaders,vals]=listinfo(T,typeobject(T));
allcheaders = h.columnheaders;
for n=2:double(allcheaders.Count)
   indx=strmatch(get(allcheaders.Item(n),'text'),cheaders);
   if ~isempty(indx)
      set(item,'SubItems',n-1,vals{n-1});  
   else
      set(item,'SubItems',n-1,'-');  
   end
end


function p= i_Current(T,h);
if h.ListItems.Count
   key= get(h.SelectedItem,'key');
   p= assign(xregpointer,sscanf(key,'K%d'));
else
   p=xregpointer;
end



function p= i_CurrentSub(T,h);
if h.ListItems.Count
   key= get(h.SelectedItem,'key');
   pindex= sscanf(key,'K%d;S%d');
   p= assign(xregpointer,pindex(2));
else
   p=xregpointer;
end


