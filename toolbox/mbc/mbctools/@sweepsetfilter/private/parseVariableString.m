function variable = parseVariableString(varString, varUnit)
%PARSEVARIABLESTRING

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:11:52 $

% Make sure inputs are strings
varString = char(varString);
varUnit = char(varUnit);

variable = struct('OK',[],...
    'inlineExp',[],...
    'result',[],...
    'varExp',[],...
    'varName',[],...
    'varString',[],...
    'varUnit',[]);

varString = strtrim(varString);
eqPosition = findstr(varString, '=');

% If no = sign found then throw an error since we have no name for the new variable
if isempty(eqPosition)
    varName = varString;
    varExp  = '';
else
    % Ensure that the varName is a validmlname
    varName = validmlname(strtrim(varString(1:eqPosition - 1)));
    varExp  = strtrim(varString(eqPosition + 1:end));
end

variable.varName   = varName;
variable.varExp    = varExp;
variable.varUnit   = strtrim(varUnit);
variable.varString = [varName ' = ' varExp];
variable.inlineExp = vectorize(mbcinline(varExp));
variable.OK        = false;        
	
%-------------------------------------------------------------------------------
% STRTRIM taken from junit to stop leading and trailing spaces getting into
%  variable names.
%-------------------------------------------------------------------------------
function str = strtrim(str)
if ~isempty(str)
	p = find(~isspace(str));
	if ~isempty(p)
		str = str(p(1):p(end));
	else
		str = '';
	end
end