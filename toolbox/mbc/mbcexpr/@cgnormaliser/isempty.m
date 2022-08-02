function empty=isempty(n)
%ISEMPTY
%
% empty = ISEMPTY(n)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:05 $

empty = isempty(n.Values) || isempty(n.Xexpr) || isempty(n.Breakpoints);