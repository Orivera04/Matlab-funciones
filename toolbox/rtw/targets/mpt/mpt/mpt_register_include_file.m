function mpt_register_include_file(fileName,includeName)

% Copyright 2002-2003 The MathWorks, Inc.

objinc=[];
objinc.name = includeName;
objinc.fileInclude = includeName;
status = register_object_with_sym(fileName,'IncludeFiles',objinc);