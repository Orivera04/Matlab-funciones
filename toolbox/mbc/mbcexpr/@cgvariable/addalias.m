function obj = addalias(obj, alstring)
%ADDALIAS Add an alias to the object
%
%  OBJ = ADDALIAS(OBJ, ALIAS_STRING)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:16:23 $ 

if ~strcmp(alstring, getname(obj)) && ~ismember(alstring, obj.Alias)
    obj.Alias = [obj.Alias; {alstring}];
end