function p = RecPos(S,ind,level);
% DATASET/RECPOS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:18:47 $

% This version calls private mex function GetRecPos and allows
% multi-level record access

% Used to deal with multi-level datasets
% Default behaviour is to look at level 1
if nargin < 3
	level = 1;
end

if islogical(ind)
   ind=find(ind);
end

% Call private function GetRecPos on S.sizes and index as uint32
p = GetRecPos(S.sizes{level}, uint32(ind));