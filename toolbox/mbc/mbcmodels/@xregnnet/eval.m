function y = eval(nn, x)
% EVAL evaluate neural network output

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:56:18 $

x=x';

y = sim(nn.param, x)';
