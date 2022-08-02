function p = RemoveRow(p,ind);
% p = RemoveRow(p,ind) removes rows in ind from operating point object p.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:19 $

if nargin~=2
    error('syntax: RemoveRow(p,ind)');
end

if any(ind<1) | any(ind>size(p.data,1))
    error('RemoveRow: bad index into rows');
end

p.data(ind,:) = [];

