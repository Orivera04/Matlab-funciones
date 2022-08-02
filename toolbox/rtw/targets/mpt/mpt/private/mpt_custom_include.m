function  mpt_custom_include(fileName,object,modelName)
%MPT_CUSTOM_INCLUDE Registers the custom include file for custom datatypes 
%
%    MPT_CUSTOM_INCLUDE(FILENAME,OBJECT,MODELNAME)
%    This function will register the custom include file for a data 
%    objects based on the data type.
%
%    Inputs:
%             fileName : source file to put the include into.
%             object   : data object information structure
%             modelName: name of the model
%    Outputs: 
%             none
%


%   Linghui Zhang
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.4.6 $  $Date: 2004/04/15 00:28:34 $
%  
%

%   get the data type

dataType = get_data_info(object.originalName,'DATATYPE',modelName);

%   get the include files associated with that datatype
includeElements =  mpt_get_include_dependency(dataType);

%  Register each include file for inclusion into that file
if isempty(includeElements{1})==0,
    for i=1:length(includeElements),
        objinc=[];
        objinc.name = includeElements{i};
        objinc.fileInclude = includeElements{i};
        status = register_object_with_sym(fileName,'IncludeFiles',objinc);
    end 
end
if exist('get_special_include_dependency','file')
    includeElements =  get_special_include_dependency(dataType);
    if isempty(includeElements{1})==0,
        for i=1:length(includeElements),
            objinc=[];
            objinc.name = includeElements{i};
            objinc.fileInclude = includeElements{i};
            status = register_object_with_sym(fileName,'IncludeFiles',objinc);
        end 
    end
end

return
