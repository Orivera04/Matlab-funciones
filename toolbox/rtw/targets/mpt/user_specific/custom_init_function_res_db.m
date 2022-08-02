function custom_init_function_res_db
%CUSTOM_INIT_FUNCTION_RES_DB Initialize the function resolution data base
%
%   CUSTOM_INIT_FUNCTION_RES_DB()
%   This function does an initial custom resolution database initialization
%   as a default. This is the legacy code integration database.
% 
%   INPUTS:
%           none
%
%   OUTPUTS:
%           none
%


%   Steve Toeppe
%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.8.4.2 $
%   $Date: 2004/04/15 00:29:21 $


global ac_fdb;

index = 1;
fdb{index}.sfFunctionName = 'LOOKUP2D';
fdb{index}.sfFunctionParam = 2;
fdb{index}.cFunctionName = 'rt_lookup2d';
fdb{index}.cFunctionParamMapping = '%P1%,%P2%';
fdb{index}.cFunXtlScript = 'custom_mpm_xlat_func';
fdb{index}.cFunReNameScript =[];
fdb{index}.cDeclarationScript = '';
fdb{index}.includeDependency{1} = '<rtlibsrc.h>';
fdb{index}.scopeRule{1} = 'C_FILE';
fdb{index}.symbol = 'GlobalCalibrationLookup1D';
fdb{index}.regSymbol=[];
fdb{index}.genRule = 'DEFAULT';
fdb{index}.paramCase=[];
fdb{index}.symbolRegistrationFunction = 'custom_reg_param';

index = index + 1;

fdb{index}.sfFunctionName = 'LOOKUP1D';
fdb{index}.sfFunctionParam = 2;
fdb{index}.cFunctionName = 'rt_lookup1d';
fdb{index}.cFunctionParamMapping = '%P1%,%P2%';
fdb{index}.cFunXtlScript = 'custom_mpm_xlat_func';
fdb{index}.cFunReNameScript =[];
fdb{index}.cDeclarationScript = '';
fdb{index}.includeDependency{1} = '<rtlibsrc.h>';
fdb{index}.scopeRule{1} = 'C_FILE';
fdb{index}.symbol = 'GlobalCalibrationLookup1D';
fdb{index}.regSymbol=[];
fdb{index}.genRule = 'DEFAULT';
fdb{index}.paramCase=[];
fdb{index}.symbolRegistrationFunction = '';
ac_fdb = fdb;
