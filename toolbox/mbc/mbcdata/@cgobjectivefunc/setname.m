function E = setname(E , str)
%SETNAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:31 $

if ischar(str)
    E.name = validmlname(str, 'A');
end