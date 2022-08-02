function INFO= getinfo(modexpr)
%GETINFO Returns structure containing model information
%
% INFO = getinfo(modexpr)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 07:13:08 $

m = get(modexpr,'model');
INFO = getinfo(m);
