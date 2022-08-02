function status = ec_mpt_enabled(modelName)

% Copyright 1994-2004 The MathWorks, Inc.
%
% $Revision: 1.1.6.3 $


cs=getActiveConfigSet(modelName);
status = (strcmp(get_param(modelName,'SimulationMode'),'normal') && ...
    strcmp(get_param(cs,'IsERTTarget'),'on') && ...
    strcmp(get_param(modelName, 'ModelReferenceTargetType'),'NONE'));

 
