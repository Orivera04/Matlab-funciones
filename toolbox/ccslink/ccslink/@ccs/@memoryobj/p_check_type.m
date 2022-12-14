function resp = p_check_type(ff,datatype)
% Private. Checks if type is an arithmetic or primitive type.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.4.2 $  $Date: 2003/11/30 23:09:23 $

if isempty( strmatch ( lower(datatype), ...
   {    'double', ... 
        'long double', ...
        'single', ...
        'float', ...
        'long', ...
        'int', ...
		'short', ...
		'char', ...
		'signed long', ...
		'signed int', ...
		'signed short', ...
		'signed char', ...
		'unsigned long', ...
		'unsigned int', ...
		'unsigned short', ...
		'unsigned char', ...
		'int64', ...
		'uint64', ...
		'int32', ...
		'uint32', ...
		'int16', ...
		'uint16', ...
		'int8', ...
		'uint8', ...
		'Q0.15', ...
		'Q0.31', ...
        'void' ...
    },  'exact' )),
    warning(generateccsmsgid('NotAValidDataType'),['DATATYPE: ' datatype ' is not a native C type or a MATLAB type ']);
    resp = 0;
else
    resp = 1;
end

% [EOF] p_check_type.m