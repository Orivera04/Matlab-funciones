function [sfDataTypeName,suffix] = determine_sf_data_type_name(dataTypeID)
%DETERMINE_SF_DATA_TYPE - determine the stateflow data name 
%
%   [SFDATATYPENAME,SUFFIX]=DERTERMINE_SF_DATATYPE_NAME(DATATYPEID)
%   This function takesin the stateflow enumerated type and returns the
%   stateflow data type and the appropriate suffix if necessary.
%
%   INPUTS:
%            dataTypeID     : The stateflow enumerated data type ID
%
%   OUTPUTS:
%            sfDataTypeName : The name of the satteflow data type as
%                             referenced by stateflow
%            suffix         : The suffix required fo this data type.
%

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.7.4.1 $  $Date: 2004/04/15 00:27:54 $

suffix = '';
switch(dataTypeID)
case 1
    sfDataTypeName = 'boolean';
case 3
    sfDataTypeName = 'uint8';
case 4
    sfDataTypeName = 'int8';
case 5
    sfDataTypeName = 'uint16';
case 6
    sfDataTypeName = 'int16';
case 7
    sfDataTypeName = 'uint32';
case 8
    sfDataTypeName = 'int32';
case 9
    sfDataTypeName = 'single';
    suffix = 'F';
case 10
    sfDataTypeName = 'double';
otherwise
    sfDataTypeName = 'UNKNOWN SF DATATYPE';
end
