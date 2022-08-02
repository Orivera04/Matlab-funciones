function p=DesignPointer(T)
% DESIGNPOINTER  Get pointer used to reference best design
%
%   PTR=DESIGNPOINTER(TP) gets a copy of the pointer which is used
%   by the testplan TP for referencing the chosen design.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:12 $

% Created 28/3/2000

p=T.Design;
return