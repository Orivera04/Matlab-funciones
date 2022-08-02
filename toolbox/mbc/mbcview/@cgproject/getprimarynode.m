function p = getprimarynode(nd,tp)
%GETPRIMARYNODE  Return the preferred node for viewing
%
%  P = GETPRIMARYNODE(ND,TP) returns a pointer to the node which 
%  is the preferred start point if ND is the first node in a tree
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/02/09 08:28:11 $


p = address(nd);
ch = p.children;
p = [];
if length(ch)
    ch = tp.filterlist(ch);
    if length(ch)
        p = ch(1);
    end
end
