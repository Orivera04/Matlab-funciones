function y= Evaluate(mdev,X);
%EVALUATE evaluate model
%
% y= Evaluate(mdev,X);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:09:47 $

y= EvalModel(model(mdev),X);
