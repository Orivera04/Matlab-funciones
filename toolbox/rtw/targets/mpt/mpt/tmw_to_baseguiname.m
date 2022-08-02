function type = tmw_to_baseguiname(dType)

%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2003/06/14 03:36:49 $

if isempty(dType) == 0
    switch(dType)
        case {'single','real32_T'},
            type = 'single';
        case {'double','real64_T','real_T'}
            type = 'double';
        case {'int16','int16_T'}
            type = 'int16';
        case {'int8','int8_T'}
            type = 'int8';
        case {'int32','int32_T'}
            type = 'int32';
        case {'uint8','uint8_T'}
            type = 'uint8';
        case {'uint16','uint16_T'}
            type = 'uint16';
        case {'uint32','uint32_T'}
            type = 'uint32';
        case {'boolean','boolean_T'}
            type = 'boolean';
        otherwise
            type =dType;
    end
else
    type =dType;
end
