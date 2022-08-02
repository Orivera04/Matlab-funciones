function  varargout=Treeview(T,Action,varargin)
% MCTREE/TREEVIEW TreeView Control from tree
%
% h=treecontrol(T,pos,fH,callbacks)
%
% where:
% pos	- a length 4 vector specifying position in pixels
% fH 	- figure handle
% callbacks - a cell array of strings specifying the event handling
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.4 $  $Date: 2004/02/09 06:48:08 $



if nargout==1
   varargout{1}=[];
end
switch lower(Action)
case 'create'
   varargout{1}= i_Create(T,varargin{:});
case 'clear'
   i_Clear(T,varargin{:});
case 'remove'
   i_Remove(T,varargin{:});
case 'add'
   i_Add(T,varargin{:});
case 'select'
   i_Select(T,varargin{:});
case 'lateselect'
	i_LateSelect(T,varargin{:});
case 'icon'
   i_Icon(T,varargin{:});
case 'replace'
   i_Replace(T,varargin{:});
case 'refresh'
   i_Refresh(T,varargin{:});
case 'current'
   varargout{1}= i_Current(T,varargin{:});
case 'key'
   varargout{1}= i_Key(T);
case 'label'
	varargout{1}= i_Label(T,varargin{:});
end



function h=i_Create(T,pos,fH,callbacks,MaxLvl);

if nargin<5
	MaxLvl=Inf;
end
	
% create ActiveX control
if nargin<4
   h = xregGui.treeview(pos,fH);
else
   h = xregGui.treeview(pos,fH,callbacks);
end
IL= imlistMBrowser(T);
h.InsertImagelist(IL);

h.Indentation=20;
h.PathSeparator='/';
h.Style= 7;
h.HideSelection = 1;
h.Parent=fH;

% add nodes to tree
i_Add(T,h,MaxLvl);


function i_Refresh(T,h,MaxLvl);

if nargin<3
	MaxLvl= Inf;
end
r=root(T);
i_Clear(T,h)
i_Add(r.info,h,MaxLvl)
i_Select(T,h);


function i_Replace(T,h);

i_Remove(T,h)
i_Add(T,h)
i_Select(T,h);


function i_Clear(T,h);
h.Nodes.Clear;


function i_Remove(T,h);
key= i_Key(T);
h.Nodes.Remove(key);


function i_Add(T,h,MaxLvl)
if nargin<3
	MaxLvl= Inf;
end

nodes= h.Nodes;
if nodes.count==0;
   root=nodes.Add;
   [ic,selic]=icon(T);
   set(root,'Text',T.Name,...
      'Image',ic,...
      'SelectedImage',selic,...
      'Tag',double(T.node),...
      'Key',i_Key(T));
   i_preorder(nodes,root,address(T),1,MaxLvl);
   h.SelectedItem = root;
else
   p= T.Parent;
   if p~=0
      key= i_Key(p.info);
      r= nodes.Item(key);
      [ic,selic]=icon(T);
      NewNode = nodes.Add(r,4,'',T.Name,ic);
      set(NewNode,'SelectedImage',selic,...
         'Tag', double(T.node),...
         'Key', i_Key(T));
      i_preorder(nodes,NewNode,address(T),1,2);
   else
      error('Invalid Tree');
   end
end

function i_Select(T,h)
key= i_Key(T);
nodes= h.Nodes;
Item= nodes.Item(key);
h.SelectedItem = Item;

function i_LateSelect(T,h)
key= i_Key(T);
nodes= h.Nodes;
Item= nodes.Item(key);
h.LateSelectedItem = Item;

function i_Icon(T,h)
key= i_Key(T);
nodes= h.Nodes;
Item= nodes.Item(key);
[ic,selic]=icon(T);
set(Item,'Image',ic,...
   'SelectedImage',selic);

function key= i_Label(T,h)
key= i_Key(T);
nodes= h.Nodes;
Item= nodes.Item(key);
Item.Text = T.Name;

function key= i_Key(T);
ind=double(T.node);
key= ['K',deblank(int2str(ind))];

function p= i_Current(T,h);
key = h.SelectedItem.Key;
p= assign(xregpointer,str2num(key(2:end)));

function i_preorder(nodes,r,p,Lvl,MaxLvl)
AllChildren= p.children;
for i=1:length(AllChildren)
   ch= AllChildren(i);
   T= ch.info;
   [ic,selic]=icon(T);
   hChild = nodes.Add(r,4,'',T.Name,ic);
   set(hChild,'Tag',double(ch),...
      'SelectedImage',selic,...
      'Key',i_Key(ch.info));
   i_preorder(nodes,hChild,ch,Lvl+1,MaxLvl);
end
if Lvl<=MaxLvl
   EnsureVisible(r);
end
return


