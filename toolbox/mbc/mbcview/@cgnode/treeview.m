function  varargout=treeview(T,Action,SI,varargin)
%TREEVIEW  TreeView actions interface
%
% treeview(T,action,SubItem,varargin)
%
%  Actions and arguments are:
%
%     Clear:  {Tree}
%     Remove: {Tree}
%     Add:    {Tree,ImageList manager, TypeFilter, MaxLvl, [alt parent]}
%     Select: {Tree}
%     LateSelect: {Tree}
%     Refresh: {Tree,ImageList manager, TypeFilter, MaxLvl}
%     Current: {Tree}
%     Currentsub: {Tree}
%     Update: {Tree,ImageList manager}

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:25:19 $


if nargout==1
   varargout{1}=[];
end
switch lower(Action)
case 'clear'
   i_Clear(T,varargin{:});
case 'remove'
   i_Remove(T,SI,varargin{:});
case 'add'
   i_Add(T,varargin{:});
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


function i_Add(T,h,varargin)
buildtree(T,h,varargin{:});

function i_Refresh(T,h,IL,tpfilter,MaxLvl);
if nargin<5
   MaxLvl= Inf;
end
r=root(T);
try
   if h.Nodes.Count
      key=h.SelectedItem.key;
   else
      key=0;
   end
catch
   key=0;
end
i_Clear(T,h)
buildtree(r.info,h,IL,tpfilter,MaxLvl);
if key
   h.SafeSelect(key);
end


function i_Clear(T,h);
h.nodes.Clear;
h.ClearLockedNodes;

function i_Remove(T,SI,h);
key= genkey(T,SI);
h.SafeRemove(key);

function i_Select(T,SI,h)
key= genkey(T,SI);
h.SafeSelect(key);

function i_LateSelect(T,SI,h)
key= genkey(T,SI);
nodes= h.nodes;
Item= nodes.Item(key);
set(h,'LateSelectedItem',Item);

function i_Update(T,SI,h,IL)
nodes= get(h,'nodes');
key= genkey(T,SI);
item= nodes.Item(key);
ic=bmp2ind(IL,iconfile(T));
set(item,'image',ic);
set(item,'text',name(T));

function p= i_Current(T,h);
if h.Nodes.Count
   key= get(h.SelectedItem,'key');
   p= assign(xregpointer,sscanf(key,'K%d'));
else
   p=xregpointer;
end

function p= i_CurrentSub(T,h);
if h.Nodes.Count
   key= get(h.SelectedItem,'key');
   pindex= sscanf(key,'K%d;S%d');
   p= assign(xregpointer,pindex(2));
else
   p=xregpointer;
end

