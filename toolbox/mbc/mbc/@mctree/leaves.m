function List= leaves(T,varargin)
%MCTREE/LEAVES Leaves of tree
%
%  List= leaves(T,varargin);
%  List= leaves(T,'func',varargin)
%  evaluates function 'func' for all leaves (botton nodes) and returns output in a cell array.
% 
%  Normally this function is called from a pointer.
%  p.leaves or p.leaves('func',args);
%
%  See also, mctree/preorder, mctree/children

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:47:54 $


if T.node~=0
   List= i_Leaf(T.node,varargin);
   if length(List)==1
      List=List{:};
   end
else
   error('Null Tree')
end

function List= i_Leaf(p,Args);

% collect outputs in a cell array
T= p.info;
ch= T.Children;
if isempty(ch)
	% only evaluate for ends of tree (no children)
	if nargin>1 
		% First element of varargin argument is function name
		% other elements are additional inputs
		List= {feval(Args{1},T,Args{2:end})};
	else
		% just return what is in the node
		List= {T};
	end
elseif all(ch~=0)
   List= cell(length(ch),1);
   for i=1:length(ch)
      % preorder each of the children 
      List{i}= i_Leaf(ch(i),Args);
   end
	List= cat(1,List{:});
end




