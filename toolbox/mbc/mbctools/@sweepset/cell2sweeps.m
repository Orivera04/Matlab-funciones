function S= cell2sweeps(S,c)
% SWEEPSET/CELL2sweeps convert cell to sweepset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:06:04 $

nv= cellfun('size',c,2);
if ~all(nv==size(S,2))
   error('Incompatible number of variables in sweepset and cell')
end
if length(c)~=size(S,3)
   error('Number of cells and sweeps must be the same')
end

S.data= cat(1,c{:});
S.baddata = sparse(size(S.data,1),size(S.data,2));


% update sweep info (in dataset object)
ts= cellfun('size',c,1);
S.xregdataset= xregdataset(testnum(S),type(S),ts(:)');


