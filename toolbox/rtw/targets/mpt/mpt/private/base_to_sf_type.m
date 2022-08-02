function sfType = base_to_sf_type(baseType)
%BASE_TO_SF_TYPE Convert Simulink Base Types to Stateflow Base Types.
%
%   SFTYPE = BASE_TO_SF_TYPE(BASETYPE)
%         Convert Simulink Base Types to Stateflow Base Types.
%   INPUT:
%         baseType: Simulink datatype
%
%   OUTPUT:
%         sfType: Stateflow datatype

%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.10.4.1 $
%   $Date: 2004/04/15 00:27:48 $

sfType=[];

switch(baseType)
case 'boolean_T'
    sfType = 'boolean';
case {'uint8_T','uint8'}
    sfType = 'uint8';
case {'int8_T','int8'}
    sfType = 'int8';
case {'uint16_T','uint16'}
    sfType = 'uint16';
case {'int16_T','int16'}
    sfType = 'int16';
case {'uint32_T','uint32'}
    sfType = 'uint32';
case {'int32_T','int32'}
    sfType = 'int32';
case 'real32_T'
    sfType = 'single';
case 'real_T'
    sfType = 'double';
otherwise
    sfType = [];
end
