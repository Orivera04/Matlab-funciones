function mySym = insymval(ddnode, pSub)
%INSYMVAL Return the cgsymvalues that a DD item is a member of 
%
%  mySym = INSYMVAL(ddnode, pSub) will return an array of pointers (mySym) to 
%  those cgsymvalues that pSub.info is a member of.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:23:30 $

allDDptrs = listptrs(ddnode);

mySym = null( xregpointer, 0 );
nToSearch = ddnode.numsymvars;
nItems = length(allDDptrs);
n=1;
while nToSearch && n<=nItems
    if issymvalue(allDDptrs(n).info)
        if ismember(pSub, allDDptrs(n).getrhsptrs)
            mySym = [mySym, allDDptrs(n)];
        end
        nToSearch = nToSearch - 1;
    end
    n = n + 1;
end