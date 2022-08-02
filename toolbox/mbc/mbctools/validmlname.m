function [validname, OK] = validmlname(name, prefix);
% VALIDMLNAME valid MATLAB variable name
%
%  [VALIDNAME, OK] = VALIDMLNAME(NAME, DEFAULT_PREFIX)
% 
%  This function takes a single string or a cell array of strings and
%  checks each for consistency with MATLAB variable names. If the name does
%  not conflict with MATLAB OK returns true, else OK is false. VALIDNAME
%  will be a modified version of NAME which does not conflict with MATLAB.
%  The DEFAULT_PREFIX ('m_' by default) will be appended to names which,
%  when modified, do not start with a letter.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:20:55 $

% Default prefix
if nargin < 2
    prefix = 'm_';
end

% Deblank the name - note this mex function is MUCH faster than deblank
name = xregdeblank(name);
% Have we been given a character array or cell array
IS_CHAR = ischar(name);
% Convert to a cell array
if IS_CHAR
    name = {name};
end
% Precreate the output arguments
OK = false(size(name));
validname = cell(size(name));
% Iterate over the cell array
for i = 1:numel(name)
    % Check if the name is OK
    [OK(i), validChars, IS_KEYWORD] = i_isvarname(name{i});
    if OK(i)
        validname(i) = name(i);
        continue
    end
    
    % If the name is not OK then need to modify it
    vname = name{i};
    % Change all spaces to '_'
    spaces = isspace(vname);
    vname(spaces) = '_';
    % Remove all elements which aren't letters, numbers or underscores or
    % spaces
    vname = vname(validChars | spaces);
    % If nothing is left then add the prefix
    if isempty(vname)
        vname = prefix;
    end
    % If the first element isn't a letter add the prefix
    if ~isletter(vname(1)) || IS_KEYWORD
        vname = [prefix vname];
    end
    % Copy back to the cell array
    validname{i} = vname;
end

if IS_CHAR
    validname = validname{1};
end

% -------------------------------------------------------------------------
% Internal version of MATLAB isvarname - modified for use here
% -------------------------------------------------------------------------
function [OK, validChars, isKeyword] = i_isvarname(s)
% Make sure the string is of class char, only contains one row, and is less
% than the maximum name length and longer than zero
[numRows, numCols] = size(s);
OK = ischar(s) && numRows == 1 && numCols <= namelengthmax && numCols > 0;
% Which characters are actually valid
validChars = isletter(s) | s == '_' | ('0' <= s & s <= '9');
% Is it a keyword?
isKeyword = i_iskeyword(s);
% Note doesn't check s(1) if not already OK
OK = OK && isletter(s(1)) && all(validChars) && ~isKeyword;

% -------------------------------------------------------------------------
% Internal version of MATLAB iskeyword - persistent should be a bit faster
% -------------------------------------------------------------------------
function OK = i_iskeyword(s)
persistent keywords
if isempty(keywords)
    keywords = {'break','case','catch','continue','else','elseif','end','for','function','global','if',...
        'otherwise','persistent','return','switch','try','while'};
end

OK = any(strcmp(s, keywords));
