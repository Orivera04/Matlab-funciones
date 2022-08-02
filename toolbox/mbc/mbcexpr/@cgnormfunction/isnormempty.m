function out = isnormempty(N)
%ISNORMEMPTY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:56 $

% Tells us whether the inputs to the table are well defined - for normfunction recursive call on normaliser

out = N.Xexpr.isnormempty;

return