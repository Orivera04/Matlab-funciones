function empty = isempty(l)
%ISEMPTY Check if object is empty
%
%  empty = isempty(l)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:11:49 $

empty = isempty(l.Values) || ...
    isempty(l.Xexpr) || ...
    isempty(l.Yexpr) || ...
    isempty(l.Xexpr.info) || ...
    isempty(l.Yexpr.info);