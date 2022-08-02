function obj = removealias(obj, alstring)
%REMOVEALIAS Remove an alias
%
%  OUT = REMOVEALIAS(obj, ALIAS_STRING)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:16:54 $ 


if ~isempty(obj.Alias)
    obj.Alias = obj.Alias(~strcmp(obj.Alias, alstring));
end