function ptrs=allchildren(T)
%ALLCHILDREN  Return a pointer array of all descendants of tree node
%
%  PTRS=ALLCHILDREN(T)  returns a pointer vector of all the nodes 
%  which are children of T, or children of children of T, etc.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:47:35 $



ptrs=i_recursivechildlist(T);


function ptrs=i_recursivechildlist(T)
ptrs=[];
for k=1:length(T.Children);
   ptrs=[ptrs T.Children(k) i_recursivechildlist(info(T.Children(k)))];
end