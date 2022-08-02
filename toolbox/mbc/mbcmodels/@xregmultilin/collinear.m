function [R2,W] = collinear(m,X);
%COLLINEAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:18 $

[R2,W] = collinear(get(m,'currentmodel'),X);