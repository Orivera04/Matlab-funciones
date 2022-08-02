function custom_include_registration(fileName)

% Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.4.3 $  $Date: 2004/04/15 00:29:20 $

objinc=[];
objinc.name = '<tmwtypes.h>';
objinc.fileInclude = '<tmwtypes.h>';
status = register_object_with_sym(fileName,'IncludeFiles',objinc);

return
