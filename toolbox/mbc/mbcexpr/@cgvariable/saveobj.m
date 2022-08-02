function obj = saveobj(obj)
%SAVEOBJ Save-time actions for variables
%
%  OBJ = SAVEOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:16:57 $ 

% The Value field is not used for permanent storage; it can be cleared on
% saving to save space in files
obj.Value = [];