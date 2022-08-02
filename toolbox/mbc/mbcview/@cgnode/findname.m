function p = findname(nd,nm,start)
%FINDNAME Find nodes with the given name
%
%  P = FINDNAME(ND,NM) returns nodes at or below ND that have the name NM.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:24:51 $

if nargin<3
    start = true;
end

if start
    p = preorder(nd, @findname, nm, false);
    if iscell(p)
        p = [p{:}];
    end
else
    if strcmp(nm,name(nd))
        p = address(nd);
    else
        p = null(xregpointer, 0);
    end
end