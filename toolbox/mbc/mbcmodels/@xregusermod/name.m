function n= name(U);
% xregusermod/NAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:30 $

if ~isempty(U.funcName)
    if ischar(U.funcName)
        n= U.funcName;
    else
        n= func2str(U.funcName);
    end
else
   n= class(U);
end
   