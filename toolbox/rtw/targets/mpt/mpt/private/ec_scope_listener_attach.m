function ec_scope_listener_attach(modelName)
%EC_SCOPE_LISTENER_ATTACH will register the EnginePostRTWCompFileNames
%listener for data placement purposes.
%
% INPUT: modelName....Name of model

%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $
%   $Date: 2003/11/19 21:40:42 $

h=get_param(modelName,'Handle');
add_engine_event_listener(h, 'EnginePostRTWCompFileNames', @ ec_mpt_listener_cb);

  