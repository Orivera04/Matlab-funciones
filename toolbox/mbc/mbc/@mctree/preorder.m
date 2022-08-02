function List= Preorder(T,varargin)
%MCTREE/PREORDER preorder traversal of tree
%
% List= preorder(T,varargin);
% List= preorder(T,'func',varargin)
%   evaluates function 'func' and returns output in a cell array.
% 
% Normally this function is called from a pointer.
%   p.preorder or p.preorder('func',args);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:48:04 $



if T.node~=0
    List= i_Preorder(T.node,varargin);
    if length(List)==1
        List=List{:};
    end
else
    error('Null Tree')
end

function List= i_Preorder(p,Args);

% collect outputs in a cell array
T= info(p);
if ~isempty(Args)
   % First element of varargin argument is function name
   % other elements are additional inputs
   List= {feval(Args{1},T,Args{2:end})};
else
   % just return what is in the node
   List= {T};
end
ch= T.Children;
if ~isempty(ch) & all(ch~=0)
   clist= cell(length(ch),1);
   for i=1:length(ch)
      % preorder each of the children 
      clist{i}= i_Preorder(ch(i),Args);
   end
   List= cat(1,List,clist{:});
end




