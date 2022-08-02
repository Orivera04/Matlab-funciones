function m= cleanup(m);
% xreglinear/CLEANUP clears stored data
%
% m= cleanup(m)
% This function clears the xreglinear 'Store' field which is used
% to store data for efficient calculation of statistics. It is not required 
% for model evaluation and so should be cleared using this method after all
% statistics have been caculated.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:16 $

tempm= cleanup(get(m,'currentmodel'));
m=set(m,'currentmodel',tempm);