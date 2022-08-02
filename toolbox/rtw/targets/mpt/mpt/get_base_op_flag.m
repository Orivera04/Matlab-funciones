function base = get_base_op_flag(modelName)
%GET_BASE_OP_FLAG determines if base ERT operation is required.
%
% BASE = GET_BASE_OP_FLAG(MODELNAME) determies if base ERT operation is
% required based upon user configuration in the MPM target configuration.
%   INPUT:
%         modelName:  Name of model (without ".mdl")
%   OUPPUT:
%         base:       Base operation flag.  1...Use base ERT, 0...Use MPM

%   Steve Toeppe
%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.7 $
%   $Date: 2002/11/01 15:24:55 $

%once the new target configuration support is provided, this flag will be
%pulled from the model file.
miscOptions = get_misc_options(modelName);
base = miscOptions.useBaseERTTemplate;
% if strcmp(miscOptions.useBaseERTTemplate,'off')
%     base = 0;
% else
%     base = 1;
% end