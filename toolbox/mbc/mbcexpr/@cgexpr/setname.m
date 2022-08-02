function E = setname(E , str)
%SETNAME Sets expression name
%
%  E = SETNAME(E, STR)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:09:48 $

if ischar(str')
    E.name = validmlname(str, 'c_');  
end