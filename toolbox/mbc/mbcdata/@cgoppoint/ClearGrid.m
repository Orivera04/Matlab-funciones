function op = ClearGrid(op,fact_i)
% op = ClearGrid(op,fact_i)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:51:09 $

f = find((op.created_flag(fact_i)==0 & ~isvalid(op.ptrlist(fact_i))) | ...
    op.created_flag(fact_i)==1);
op.grid_flag(fact_i) = 0;
op.constant(fact_i) = mean(op.data(:,fact_i));
op.range(fact_i) = {[]};

if ~isempty(f)
    % If here we are going to remove this imported data
    % Caveat : Caller MUST check to ensure that removing this
    % data does not invalidate other data set factors
    op = removefactor(op,fact_i(f));
end
