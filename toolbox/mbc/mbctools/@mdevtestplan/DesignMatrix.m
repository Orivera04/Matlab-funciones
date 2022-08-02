function M = DesignMatrix(T);
%DESIGNMATRIX design matrix of outer (global) level
%
% M= DesignMatrix(T);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $  $Date: 2004/04/04 03:31:28 $

des = getdesign(T.DesignDev);
m = model(des);
M = invcode(m , factorsettings(des));
