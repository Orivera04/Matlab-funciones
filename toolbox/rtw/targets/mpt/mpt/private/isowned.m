function status = isowned(name,moduleName,modelName)
%ISOWNED Is used to check the status of the owner attribute of a data object
%
%   [STATUS]=ISOWNED(NAME,MODELNAME,MODELNAME)
%   This function used to check the owner of a data object "name".  If the 
%   modeleName is empty then the status returned is 1. If the 
%   owner field is empty  or the owner field and the moduleName are the same 
%   the status returned is 1, otherwise the status returned is 0.  
%
%   INPUTS:
%          name       : name of the Simulink data Object this is associated
%          moduleName : The model we will associate this with
%          modelName  : name of the model which is using the data Object
%
%   OUTPUTS:
%          status     : Status flag indicating the owner status with
%                       respect to moduleName
%

%   Steve Toeppe
%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.11.4.2 $
%   $Date: 2004/04/15 00:28:20 $

status = 1;

if isempty(deblank(moduleName)) == 1
    return;
end

try
 dataStr = get_data_info(name,'OWNER',modelName);
 if isempty(deblank(dataStr)) == 1
     status = 1;
 elseif strcmpi(moduleName,dataStr) == 1
     status = 1;
 else
     status = 0;
 end
catch
end