function init_data_mapping
%INIT_DATA_MAPPING establishes declaration and refrence information for objects
% 
%   INIT_DATA_MAPPING()
%   This function establishes information declaration and reference rules
%   for various data objects and storage class categories. This function
%   initializes the default categories. Additional mapping rules can be
%   established by the user to handle special cases or to override the default
%   cases.
%
%   INPUTS:
%           none
%
%   OUTPUTS: 
%           none
%


%   Steve Toeppe
%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.13.4.3 $
%   $Date: 2004/04/15 00:28:13 $


% This function should be called once during initial code generation
% process.
% mapping{..}.object_type_name = {'ARRAY','REGISTER','CALIBRATION','TIMER','FLAG','user defined'}
%            .storage_class{..}.storage_class_name = {'ROM','CAL','RAM','KAM','pragma_name','user_defined'}
%            .storage_class{..}.define_category{..}.define_name = {'declare','reference'}
%                                                   symbol_name = {any registered symbol}

establish_data_mapping;

set_data_mapping('ARRAY','ROM','GlobalCalibrationScalar','ExternalCalibrationScalar', ...
    'LocalCalibrationScalar', 'FilescopeCalibrationScalar');
set_data_mapping('ARRAY','RAM','GlobalVariableScalar','ExternalVariableScalar', ...
    'LocalVariableScalar', 'FilescopeVariableScalar');
set_data_mapping('ARRAY','KAM','GlobalVariableScalar','ExternalVariableScalar', ...
    'LocalVariableScalar', 'FilescopeVariableScalar');

%%%%%%%%%%%% CustomStorageClass: MPT %%%%%%%%%%%%%%%%%%%
set_data_mapping('MPT','ROM','GlobalCalibrationScalar','ExternalCalibrationScalar', ...
    'LocalCalibrationScalar','FilescopeCalibrationScalar');
set_data_mapping('MPT','RAM','GlobalVariableScalar','ExternalVariableScalar', ...
    'LocalVariableScalar', 'FilescopeVariableScalar');
set_data_mapping('MPT','KAM','GlobalVariableScalar','ExternalVariableScalar', ...
    'LocalVariableScalar', 'FilescopeVariableScalar');
set_data_mapping('MPT','REG','GlobalVariableScalar','ExternalVariableScalar', ...
    'LocalVariableScalar', 'FilescopeVariableScalar');
set_data_mapping('MPT','#DEFINE','LocalDefines','LocalDefines', ...
    'LocalDefines', 'LocalDefines');
%%%%%%%%%%%% End %%%%%%%%%%%%%%%%%%%

set_data_mapping('SCALAR','ROM','GlobalCalibrationScalar','ExternalCalibrationScalar', ...
    'LocalCalibrationScalar', 'FilescopeCalibrationScalar');
set_data_mapping('SCALAR','RAM','GlobalVariableScalar','ExternalVariableScalar', ...
    'LocalVariableScalar', 'FilescopeVariableScalar');
set_data_mapping('SCALAR','KAM','GlobalVariableScalar','ExternalVariableScalar', ...
    'LocalVariableScalar', 'FilescopeVariableScalar');
set_data_mapping('SCALAR','REG','GlobalVariableScalar','ExternalVariableScalar', ...
    'LocalVariableScalar', 'FilescopeVariableScalar');
set_data_mapping('SCALAR','#DEFINE','LocalDefines','LocalDefines', ...
    'LocalDefines', 'LocalDefines');

set_data_mapping('TIMER','ROM','GlobalCalibrationScalar','ExternalCalibrationScalar', ...
    'LocalCalibrationScalar', 'FilescopeCalibrationScalar');
set_data_mapping('TIMER','RAM','GlobalVariableTimer','ExternalVariableTimer', ...
    'LocalVariableTimer', 'FilescopeVariableTimer');
set_data_mapping('TIMER','KAM','GlobalVariableTimer','ExternalVariableTimer', ...
    'LocalVariableTimer', 'FilescopeVariableTimer');
set_data_mapping('TIMER','REG','GlobalVariableTimer','ExternalVariableTimer', ...
    'LocalVariableTimer', 'FilescopeVariableTimer');

set_data_mapping('FLAG','ROM','GlobalCalibrationScalar','ExternalCalibrationScalar', ...
    'LocalCalibrationScalar', 'FilescopeCalibrationScalar');
set_data_mapping('FLAG','RAM','GlobalVariableFlag','ExternalVariableFlag', ...
    'LocalVariableFlag', 'FilescopeVariableFlag');
set_data_mapping('FLAG','KAM','GlobalVariableFlag','ExternalVariableFlag', ...
    'LocalVariableFlag', 'FilescopeVariableFlag');
set_data_mapping('FLAG','REG','GlobalVariableFlag','ExternalVariableFlag', ...
    'LocalVariableFlag', 'FilescopeVariableFlag');
set_data_mapping('FLAG','#DEFINE','LocalDefines','LocalDefines', ...
    'LocalDefines', 'LocalDefines');

set_data_mapping('STRUCTURE','ROM','GlobalCalibrationScalar','ExternalCalibrationScalar', ...
    'LocalCalibrationScalar', 'FilescopeCalibrationScalar');
set_data_mapping('STRUCTURE','RAM','GlobalVariableScalar','ExternalVariableScalar', ...
    'LocalVariableScalar', 'FilescopeVariableScalar');
set_data_mapping('STRUCTURE','KAM','GlobalVariableScalar','ExternalVariableScalar', ...
    'LocalVariableScalar', 'FilescopeVariableScalar');
set_data_mapping('STRUCTURE','REG','GlobalVariableFlag','ExternalVariableFlag', ...
    'LocalVariableScalar', 'FilescopeVariableScalar');

mpt_init_custom_mapping;
