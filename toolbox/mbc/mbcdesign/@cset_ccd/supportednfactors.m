function [Min, Max, Allowed]=supportednfactors(obj)
%SUPPORTEDNFACTORS  Return information about limits on number of factors in design
%
%  [MIN, MAX, ALLOWEDLIST]=SUPPORTEDNFACTORS(OBJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:00:18 $

% default is to allow all settings
Min=2;
Max=16;
Allowed=[];