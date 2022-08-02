function UnitObj = displayname2junit(UnitStr)
%DISPLAYNAME2JUNIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:48:27 $

%DISPLAYNAME2JUNIT  Construct a junit from its display name.  Note that this
%   should only be used on valid display names, 
%
%   UnitObj = DISPLAYNAME2JUNIT(UnitStr) constructs a junit from its display
%   name.

% ---------------------------------------------------------------------------
% Description : Method to list registered dimensions for a quantity type.
% Inputs      : UnitStr - display name (str)
% Outputs     : UnitObj - unit (junit)
% ---------------------------------------------------------------------------

UnitStr = i_check(UnitStr, 'UnitStr');

% Handle empty strings
if isempty(UnitStr)
    UnitObj = junit;
    return
end

% Create parsable string from display name
% Trim leading and trailing spaces
parsableUnitStr = strtrim(UnitStr);
% Check if parsableUnitStr ends with '(difference)'
isDifferenceUnitStr = 0;
if (length(parsableUnitStr) >= 12)
	isDifferenceUnitStr = strcmp(parsableUnitStr(end-11:end), '(difference)');
	if isDifferenceUnitStr
		% Remove '(difference)', we will add it again later
		parsableUnitStr = strtrim(parsableUnitStr(1:end-12));
	end
end
% Have we got a number or a minus at the beginning
firstChar = parsableUnitStr(1);
spacesToReplace = find(isspace(parsableUnitStr));
% Check for '-' or '0' to '9'
if (firstChar == 45 | (firstChar >= 48 & firstChar <= 57))
	 spacesToReplace = spacesToReplace(2:end);
end
% Replace spaces with underscores
parsableUnitStr(spacesToReplace) = '_';

if isDifferenceUnitStr
    % Add '(difference)'
    parsableUnitStr = [parsableUnitStr ' (difference)'];
end

% Construct junit
UnitObj = junit(parsableUnitStr);

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'UnitStr'
    if ~ischar(in)
        % UnitStr is not a string
        error([mfilename ': ' VarName ' must be a string']);
    elseif size(in,1)>1
        % UnitStr is an array of strings
        error([mfilename ': ' VarName ' must be a single string']);
    else
        % UnitStr is valid
        out = in;
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch

% ---------------------------------------------------------------------------

function strOut = strtrim(strIn)

strOut = deblank(strIn);
strOut = fliplr(strOut);
strOut = deblank(strOut);
strOut = fliplr(strOut);
