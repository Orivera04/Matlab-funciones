function pos = getFactorIndex(op,ptr)
% getFactorIndex(op,ptr)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:42 $


plist= op.ptrlist;
ftype= op.factor_type~=3;
pos = findptrs(ptr,op.ptrlist);

% remove linked factor with copied data
ftype3= find(op.factor_type==3);
if ~isempty(ftype3)
    pos( ismember(pos,find(op.factor_type==3)) )= 0;
end
