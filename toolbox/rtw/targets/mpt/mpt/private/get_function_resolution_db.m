function fdb = get_function_resolution_db
%GET_FUNCTION_RESOLUTION_DB returns the function resolution database.
%
%   [FDB]= GET_FUNCTION_RESOLUTION_DB
%   This function returns the present values of the global variable fdb
%   this global variable represents the function resolution data base for
%   legacy code integration.
%
%   INPUTS:
%            none
%
%   OUTPUTS:
%            fdb   : Structure containing all the registered legacy
%                    functions
%

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.8.4.1 $  $Date: 2004/04/15 00:28:07 $


global ac_fdb;
fdb = ac_fdb;