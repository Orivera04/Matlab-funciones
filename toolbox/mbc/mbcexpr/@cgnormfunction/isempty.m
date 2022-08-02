function empty=isempty(n)
% cgnormfunction\isempty
% empty = isempty(n)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:14:54 $

% need to use short-circuiting here
empty = isempty(n.Values) || isempty(n.Xexpr) || isempty(n.Xexpr.info);