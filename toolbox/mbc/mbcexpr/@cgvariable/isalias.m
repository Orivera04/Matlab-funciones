function ret = isalias(obj, alstring)
%ISALIAS Check whether name is defined as an alias
%
%  ISALIAS(OBJ, ALSTRING) returns true if ALSTRING is defined as an alias
%  in OBJ, false otherwise.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:16:43 $ 

ret = any(strcmp(obj.Alias, alstring));
