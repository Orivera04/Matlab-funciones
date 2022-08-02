function ok = rename(nd,nm)
%RENAME Rename a node
%
%  [ND,OK]=RENAME(ND,NAME) attempts to rename ND and returns 1 if
%  successful, 0 otherwise.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:25:16 $

if isvarname(nm)
    p = project(nd);
    ok = isuniquename(p,nm);
    if ok
        nd = name(nd,nm);  
    end
else
    ok=0;
end
