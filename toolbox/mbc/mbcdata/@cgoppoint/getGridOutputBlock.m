function out_i = getGridOutputBlock(op)
% out_i = getGridOutputBlock(op)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:46 $

block_i = find(op.grid_flag==7);
in_i = find(op.factor_type==1);
out_i = setdiff(block_i,in_i);
