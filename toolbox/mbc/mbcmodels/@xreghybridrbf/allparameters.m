function b= allparameters(m)
%XREGHYBRIDRBF/ALLPARAMETERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:47:58 $

Ball= double(m);
m= update(m,Ball);
b = [Ball(1:size(m.linearmodpart,1)); allparameters(m.rbfpart)];
