function nOut = nargout(obj)
% MBCINLINE/NARGOUT
%
% Number of output arguments from an mbcinline object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 06:45:12 $

nOut = 1;

if ~isempty(obj.funcHandle)
    strFuncHandle = func2str(obj.funcHandle);
    if exist(strFuncHandle) == 2
        nOut = nargout(strFuncHandle);
    end
end