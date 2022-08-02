function init_function_resolution_db
%INIT_FUNCTION_RESOLUTION_DB Initialize the global variable ac_fdb
%
%   INIT_FUNCTION_RESOLUTION_DB()
%   This function will establish the global function resolution database
%   varaiable ac_fdb for legacy code inclusion.
%
%   INPUTS:
%            none
%
%   OUTPUTS:
%            none
%

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.10.4.1 $
%   $Date: 2004/04/15 00:28:14 $


global ac_fdb;
ac_fdb = [];

