function obj = setname(obj , str)
%SETNAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:56 $

if ischar(str)
    obj.name = validmlname(str, 'A');
end