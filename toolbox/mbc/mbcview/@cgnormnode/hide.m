function [data,OK] = hide(node,CBH,data)
%HIDE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:33:23 $

if ~isempty(data.Store)
    % set all inputs back to their proper values
    for n=1:length(data.Store.VarPtrs)
        ptr = data.Store.VarPtrs(n);
        ptr.info = ptr.set('value',data.Store.VarVals{n});
    end
    for n=1:length(data.Store.ConstPtrs)
        ptr = data.Store.ConstPtrs(n);
        ptr.info = ptr.set('value',data.Store.ConstVals{n});
    end
end
pMessage(data, '');

OK = 1;
