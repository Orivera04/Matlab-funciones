function p=TreeIndex(T,index);
%TREEINDEX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:33 $

if nargin==2;
   T.TreeIndex= index;
   p=pointer(T);
   p=T;
else
   p= T.TreeIndex;
end
