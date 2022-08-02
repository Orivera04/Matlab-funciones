function rehash(obj)
% REHASH  Force a reread of available candidate sets
%
%   REHASH(OBJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:26 $

% Created 5/11/2000

% Use an undocumented "get" feature to access the data

out=get(obj,'dorehash');
return