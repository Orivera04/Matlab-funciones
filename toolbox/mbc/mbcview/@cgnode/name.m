function str = name(nd,newname)
%NAME Return or set name for node
%
%  N = NAME(NODE)
%  N = NAME(NODE, SUBITEM)
%  NODE = NAME(NODE, N);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:25:10 $

% This method is overloaded to add support for the syntax 
% name(pItem, pSubItem) which is used in cage

if nargin==1 || (nargin==2 && ~ischar(newname))
    str = name(nd.mctree);
else
    nd.mctree = name(nd.mctree, newname);
    pointer(nd);
    str = nd;
end