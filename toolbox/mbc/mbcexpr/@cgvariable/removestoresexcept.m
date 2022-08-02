function obj = removestoresexcept(obj, validstores)
%REMOVESTORESEXCEPT Remove unused stores from object
%
%  OBJ = REMOVESTORESEXCEPT(OBJ, VALIDSTORES) removes all soters except
%  those specified in VALIDSTORES.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:16:56 $ 

removalstores = setdiff(obj.BackupGUIDs, validstores);
obj = removestore(obj, removalstores);