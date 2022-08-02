function rollcb(rl)
%ROLLER/ROLLCB   Callback function
%   Callback function for rolling a roller on a button click

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:25 $


set(rl,'value',~get(rl,'value'));

% activate callback
cbactivate(rl);


