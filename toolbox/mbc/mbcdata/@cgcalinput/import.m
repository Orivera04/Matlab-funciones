function out = import(obj)
% cgcalinput/import

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:49:20 $

out = [];
if ~isempty(obj.inputFcn)
    out = feval(obj.inputFcn,obj);
end