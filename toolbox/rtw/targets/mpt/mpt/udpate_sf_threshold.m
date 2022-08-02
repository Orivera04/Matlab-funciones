function udpate_sf_threshold(modelName)
%UDPATE_SF_THRESHOLD set the threshold for inlines
%
%   UDPATE_SF_THRESHOLD(MODELNAME)
%         set the threshold for inlines with the value from MPM
%         misc options
%
%   INPUT:
%         modelName: Name of the model

%   Copyright 1986-2002 The MathWorks, Inc.
%   $Revision: 1.5 $
%   $Date: 2002/04/14 17:38:27 $

miscOptions = get_misc_options(modelName);
sfc('coder_options','inlineThreshold',miscOptions.StateflowThreshold);
