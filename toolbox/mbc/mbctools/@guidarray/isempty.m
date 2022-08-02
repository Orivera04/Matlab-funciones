function OK = isempty(obj)
%GUIDARRAY/ISEMPTY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

OK = numel(obj.values) == 0;