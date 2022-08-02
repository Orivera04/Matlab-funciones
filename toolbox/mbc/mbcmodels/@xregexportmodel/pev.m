function [p,yhat]=pev(M,values,varargin);
%XREGEXPORTMODEL/PEV
% Unless this is overloaded by a child both return arguments will
% be empty.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:38 $
p = [];
if nargout>1
    yhat = eval(M,values);
end

