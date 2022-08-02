function [ret,pDS] = indataset(ddnode, pVar)
%INDATASET Check for item being in a dataset
%
%  [RET, PDSETS] = INDATASET(DD, pITEM)  Checks whether PITEM is used in
%  any datasets in the session.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:23:29 $ 

Proj = project(ddnode);
nodes=filterbytype(Proj,cgtypes.cgdatasettype);
ret = false;
pDS = assign(xregpointer, []);

for n =1:length(nodes)
    node = nodes{n};
    pOp = getdata(node);
    opDeps = get(pOp.info, 'ptrlist');
    % Is the variable in the dataset
    if any(opDeps == pVar)
        ret = true;
        ptr = address(node);
        pDS = [pDS, ptr ];
    end
end
