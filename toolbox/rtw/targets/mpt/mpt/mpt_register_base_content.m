function mpt_register_base_content(modelName,fileName, Content)
%MPT_REGISTER_BASE_CONTENT registers base RTW-EC symbols.
%
%  MPT_REGISTER_BASE_CONTENT(MODELNAME,FILENAME,CONTENT)
%         reisters the RTW-EC base symbols with the associated file names.
%
%   INPUT:
%         modelName:      Name of model
%         fileName:       Name of file that symbols are associated
%         Content:        RTW-EC symbol buffer
%

%   Steve Toeppe
%   Copyright 2002 The MathWorks, Inc.
%
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/15 00:27:37 $

global ecac;


   if strcmp(fileName,ecac.filterFileName) == 1
       filterFileFlag = 1;
   else
       filterFileFlag = 0;
   end



symNameList = fieldnames(Content);
for i=1:length(symNameList)
    if filterFileFlag & strcmp(ecac.filterSymbol,symNameList{i})
    symContent = '';
    else
             symContent = getfield(Content,symNameList{i});
       
    end
    object=[];
    object.name = symContent;
    status = register_object_with_sym(fileName, symNameList{i} ,object);
end