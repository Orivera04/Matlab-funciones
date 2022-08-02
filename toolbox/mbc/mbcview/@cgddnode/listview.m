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


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:23:35 $


switch lower(Action)
case 'update'
	i_Update(T,SI,varargin{:});
otherwise
   % pass on to cgnode
   varargout{1}= listview(T.cgcontainer,Action,SI,varargin{:});
end


function i_Update(T,SI,h,IL)
% update the list item with the current sub item information
[tags,vals]=listvals(T,SI);

nodes= get(h,'listitems');
key= genkey(T,SI);
item= nodes.Item(key);
ic=bmp2ind(IL,iconfile(T,SI));
set(item,'smallicon',ic);
set(item,'text',SI.getname);

for n=1:length(vals)
   set(item,'SubItems',n,vals{n});  
end



