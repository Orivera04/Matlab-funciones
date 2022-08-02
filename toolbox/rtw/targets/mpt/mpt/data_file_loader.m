function data_file_loader(modelName)
%DATA_FILE_LOADER - Data File Loader Block
%
%   DATA_FILE_LOADER(MODELNAME) This function locates all instances
%   of the masked block 'DataFileLoader' in a model. It then extracts
%   the names of the data-file scripts from these blocks. When these scripts
%   are executed, they generate temporary variables for the data they
%   contain. Then, if a data object exists in the base workspace and has the
%   same name as the temporary variable, that object's value is
%   updated with the value of the temporary variable. If a data object
%   does not exist in the base workspace, the temporary variable is added
%   to the workspace.
%
%   INPUT:
%         modelName:  String, name of model


%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.6.4.3 $
%   $Date: 2004/04/15 00:26:36 $

%
% Extract all of the data file blocks from the model
%

dataFileBlocks = find_system(modelName,'BlockType','SubSystem','MaskType','DataFileLoader');

% 
%  Next extract all of the script names from the data file loader blocks.
%  
cnt = 1;

for i=1:length(dataFileBlocks),
   temp = get_param(dataFileBlocks(i),'data_file');
   if strcmp(temp,'<DataFileName>')==0,
      if isempty(deblank(temp))==0,
        scriptName{cnt} = temp;
        cnt = cnt + 1;
      end    
   end
   
end

%
% Next update the data objects/workspace by running these script files listed.
%

if exist('scriptName','var')==1,
  for i=1:length(scriptName)
    object_update(char(scriptName{i}));
  end
end
%
%  return from function after all the data file loader blocks are.
%

return;