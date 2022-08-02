function status = isactive(modelName)
%ISACTIVE returns a flag indicating if a model is the current active model.
%
%   [STATUS]=isactive(MODELNAME)
%   This function returns a flag indicating if a model is the current
%   active model or not, the return is 1 if the model is active and a 0 if
%   the model is inactive.
%
%   INPUTS:
%            modelName : Name of model to check on
%     
%   OUTPUTS:
%            status    : return value indicating if model is active or not
%                        1 is active, 0 is inactive
                         
%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.8.4.1 $  $Date: 2004/04/15 00:28:19 $

global activeModel

try
    if strcmpi(modelName,activeModel) == 1
        status = 1;
    else
        status = 0;
    end
catch
    status = 0;
end

