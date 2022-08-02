function List= postorder(T,varargin)
%POSTORDER Postorder traversal of tree
%
%  List = POSTORDER(T,varargin)
%  List = POSTORDER(T,'func',varargin) evaluates function 'func' and returns
%  output in a cell array.
% 
%  Normally this function is called from a pointer:
%
%      p.postorder  or  p.postorder('func',args);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $  $Date: 2004/02/09 06:48:03 $

if T.node~=0
   List= i_postorder(T.node,varargin);
   if length(List)==1
      List=List{:};
   end
else
   error('Null Tree')
end

function List= i_postorder(p,Args);

% collect outputs in a cell array
T= info(p);
List={};
ch= T.Children;
if ~isempty(ch) & all(ch~=0)
   clist= cell(length(ch),1);
   for i=1:length(ch)
      % preorder each of the children 
      clist{i}= i_postorder(ch(i),Args);
   end
   List= cat(1,List,clist{:});
end

if ~isempty(Args)
   % First element of varargin argument is function name
   % other elements are additional inputs
   List= [List ; {feval(Args{1},T,Args{2:end})}];
else
   % just return what is in the node
   List= [List;{T}];
end




