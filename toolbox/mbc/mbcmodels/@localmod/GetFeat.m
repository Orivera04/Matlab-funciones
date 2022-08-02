function [Value,Type]=GetFeat(L,ind);
% LOCALMOD/GETFEAT get response feature info
%
% [Value,Type]=GetFeat(L,ind);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:40 $

Type= L.Type(ind);
Value= L.Values(ind,:);