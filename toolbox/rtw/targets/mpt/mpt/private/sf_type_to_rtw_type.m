function [rtwDataTypeName] = sf_type_to_rtw_type(dataTypeID)
%SF_TYPE_TO_RTW_TYPE  -  Coverts a Stateflow Data type to RTW Data Type 
%
%   [rtwDataTypeName]=SF_TYPE_TO_RTW_TYPE(dataTypeID)
%   This function takes in the stateflow enumerated type or the data type
%   supplied and converts it to the corresponding RTW Data Type as will
%   show up in generated code.
%
%   INPUTS:  dataTypeID : either the stateflow enumerated value (1-10) 
%                         or the base type double, single, uint16 ...
%
%   OUTPUT: rtwDataType : The RTW data type that correseponds to the sf data 
%                         supplied as an input argument.


%   $Date: 2004/04/15 00:28:54 $
%   $Revision: 1.10.4.2 $
%   Copyright 2002-2003 The MathWorks, Inc.
%

%
% Servide the internal hook to translate data types to custiomer specific
%  
%
dataTypeID = get_mpt_data_registry('dataType',dataTypeID);

%
% convert the translated data type from stateflow to an RTW data type.
%

switch(dataTypeID)
case 0
    rtwDataTypeName = 'real_T';        
case 1
    rtwDataTypeName = 'boolean_T';
case 3
    rtwDataTypeName = 'uint8_T';
case 4
    rtwDataTypeName = 'int8_T';
case 5
    rtwDataTypeName = 'uint16_T';
case 6
    rtwDataTypeName = 'int16_T';
case 7
    rtwDataTypeName = 'uint32_T';
case 8
    rtwDataTypeName = 'int32_T';
case 9
    rtwDataTypeName = 'real32_T';
case 10
    rtwDataTypeName = 'real_T';  
case 'boolean'
    rtwDataTypeName = 'boolean_T';
case 'uint8'
    rtwDataTypeName = 'uint8_T';
case 'int8'
    rtwDataTypeName = 'int8_T';
case 'uint16'
    rtwDataTypeName = 'uint16_T';
case 'int16'
    rtwDataTypeName = 'int16_T';
case 'uint32'
    rtwDataTypeName = 'uint32_T';
case 'int32'
    rtwDataTypeName = 'int32_T';
case 'single'
    rtwDataTypeName = 'real32_T';
case 'double'
    rtwDataTypeName = 'real_T';
otherwise
    rtwDataTypeName = 'UNKNOWN SF DATATYPE';
end

return