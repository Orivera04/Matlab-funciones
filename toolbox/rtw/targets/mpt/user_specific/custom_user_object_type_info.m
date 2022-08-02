function  objectType = custom_user_object_type_info
%CUSTOM_USER_OBJECT_TYPE_INFO Specifies user object type information
% 
%   CUSTOM_USER_OBJECT_TYPE_INFO()
%   This function provides object type infomation for code 
%   generation and its data dictionary.
%
%   INPUT:
%         none
%   OUTPUT: 
%         objectType: a cell array with user provided object type information
%                     in each structure for each object type.  
%
%  The full list of field names for each structure:
%         Name:      Name of a object type.
%         Type:      Data object type. It can be one of the three types of 
%                    'Parameter', 'Signal' and 'Both'.
%         DataType:  Real data type. It can be one of user-defined data types 
%                    or Mathworks data types (int8, uint8, int16,uint16,int32
%                    uint32, double, single, boolean). 
%         Units:     Corresponds to "DocUnits" property of MPT data object.
%         Owner:     Corresponds to "Owner" property of MPT data object.
%         Level:     Corresponds to "DisplayLevel" property for Signal or 
%                    "TuneLevel" property for Parameter property of MPT data
%                    object.
%         InitValue: Corresponds to "InitialValue" property for MPT Signal object. 
%         Value:     Corresponds to "Value" property for MPT Parameter object. 

%         Max:       Corresponds to "Maximum" or "MaxValue" property of MPT 
%                    data object. 
%         Min:       Corresponds to "Minimum" or "MinValue" property of MPT 
%                    data object. 
%         DefinitionFile: Corresponds to "DefinitionFile" property of MPT 
%                         data object.
%         Description: Corresponds to "Description" property of MPT data
%                      object.
%         HeaderFile: Corresponds to "HeaderFile" property of MPT data object
%         CustomStorageClass: Corresponds to "CustomStorageClass" property of  
%                             MPT data object.
%         AliasOverrides: Correspongs to "Alias overrides naming rule" of MPT 
%                         data object.  1-check, 0-uncheck.
%
%  You need to provide necessary information for the fields in each structure
%  for each object type. The fields "Name", "Type" and "DataType" must be 
%  specified. The remaining fields correspend to mpt.Parameter and mpt.Signal
%  properties. For these fields, you have the choice to specifying or not 
%  specifying values for one or more of properties. If you specify a value, that
%  value will appear automatically in the corresponding field of the data
%  object, when you select the user object type for the data object. If you do
%  not specify a value, the default value will appear in the corresponding
%  field.
%
%  To specify user object type information, use the format as shown in the 
%  following example: 
%         An example for specifying two object types 
%         ('EngineSpeedType' and 'CalType'):
%
%  ************* Beginning of 'EngineSpeedType' object type ********
%     objectType{end+1}.Name = 'EngineSpeedType';
%     objectType{end}.Type = 'Signal';
%     objectType{end}.DataType = 'S32';
%     objectType{end}.Units = 'rmp';
%     objectType{end}.DefinitionFile = 'EngSpeedDef';
%     objectType{end}.Description = 'This is Engine Speed Type';
%     objectType{end}.CustomStorageClass = 'Global';
%     objectType{end}.AliasOverrides = 1;
%     objectType{end}.Level = 5;
%  ************* End of 'EngineSpeedType' object type *************
%
%  ************* Beginning of 'CalType' object type ***************
%     objectType{end+1}.Name = 'CalType';
%     objectType{end}.Type = 'Parameter';
%     objectType{end}.DataType = 'single';
%     objectType{end}.CustomStorageClass = 'Const';
%     objectType{end}.HeaderFile = 'CalibrationInclude';
%     objectType{end}.Value = 5;
%  ************* End of 'CalType' object type *********************
%
%%%%%%%%%%%%%%%%%%%%%%This is a invalid object type %%%%%%%%%%%%%%%%   
% objectType{end+1}.Name = 'WrongType';
% objectType{end}.Type = 'Parameter';
% objectType{end}.DataType = 'notRegisteredType';  
% %  It is invalid because its real data type is neither one of 
% %  user-defined data types nor one of Mathworks data types. 
%%%%%%%%%%%%%%%%%%%%%%%%%End%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Note: This file has to be on the Matlab path.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/15 00:29:23 $

objectType = ''; % Do not delete this line.

%%% You may modify code below by uncommenting code lines and placing 
%%% necessary information on the right side of "="

% objectType{end+1}.Name = 'EngineSpeedType';
% objectType{end}.Type = 'Signal';
% objectType{end}.DataType = 'us8';    
% objectType{end}.Units = 'rmp';
% objectType{end}.DefinitionFile = 'EngSpeedDef';
% objectType{end}.Description = 'This is Engine Speed Type';
% objectType{end}.CustomStorageClass = 'Global';
% objectType{end}.AliasOverrides = 1;
% objectType{end}.Level = 5;
% 
% objectType{end+1}.Name = 'CalType';
% objectType{end}.Type = 'Parameter';
% objectType{end}.DataType = 'single';
% objectType{end}.CustomStorageClass = 'Const';
% objectType{end}.HeaderFile = 'CalibrationInclude';
% objectType{end}.Value = 5;
%
% objectType{end+1}.Name = 'AirFlowInSpeedType';
% objectType{end}.Type = 'Both';
% objectType{end}.DataType = 'AirFlowInSpeedType';    %int32
% objectType{end}.Units = 'mm^3/s';
% objectType{end}.Min = -2^12;
% objectType{end}.Max = 2^12';
