function m= cleanup(m);
% CLEANUP clears stored data
%
% m= cleanup(m)
% This function clears the xreglinear 'Store' field which is used
% to store data for efficient calculation of statistics. It is not required 
% for model evaluation and so should be cleared using this method after all
% statistics have been caculated.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:58:17 $


%m.mv3xspline= set(m.mv3xspline,'Store',[]);
