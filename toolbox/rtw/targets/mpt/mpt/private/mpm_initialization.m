function mpm_initialization(targetId, modelName)
%MPM_INITIALIZATION is used to initialize the module packaging manager.
%
%   MPM_INITIALIZATION(TARGETID, MODELNAME) 
%        It will initialize module packaging manager per the target.
%
%   INPUTS:
%        targetId:           handle of target in SFC
%        modelName:    name of the model
%         
%   OUTPUT:
%         none

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.12.4.2 $
%   $Date: 2004/04/15 00:28:29 $

%
% Register user date types
%
user_type_registration;


%
% Initialize the function database
%
init_function_resolution_db;

% 
% Initialize symbol names and associated resolution functions
%
init_symbol_db;


init_base_ert_symbol_db;