function UnitList = listunits(UnitObj, varargin)
%LISTUNITS

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:37 $

%JUNIT/LISTUNITS  List registered units for the quantity type(s)
%   corresponding to a unit.
%
%   UnitList = LISTUNITS(UnitObj) lists the registered units UnitList
%   for the quantity type(s) corresponding to a unit UnitObj.
%
%   UnitList = LISTUNITS(UnitObj, 'compatible') lists the
%   registered units UnitList for the quantity type(s) compatible
%   with a unit UnitObj.

% ---------------------------------------------------------------------------
% Description : Method to list registered dimensions for a quantity type
%               corresponding to a unit.
% Inputs      : UnitObj  - unit (junit)
%               option   - optional switch, 'compatible' is supported
% Outputs     : UnitList - list of registered units ({str})
% ---------------------------------------------------------------------------

% Error check on UnitObj
UnitObj = i_check(UnitObj, 'UnitObj');

% If junit is invalid, warn and return empty
if ~isvalid(UnitObj)
    warning(['invalid junit ' char(UnitObj)]);
    UnitList = [];
    return
end

if nargin == 1
    % List units
    UnitList = listunits(quantity(UnitObj));
else
    % Error check on option
    option = i_check(varargin{1}, 'option');
    % List units
    UnitList = listunits(quantity(UnitObj, option));
end

% Append '(difference)' to difference units
if isdifference(UnitObj) & ~isempty(UnitList)
    UnitList(~strcmp(UnitList, '')) = strcat(UnitList(~strcmp(UnitList, '')), ' (difference)');
    UnitList(strcmp(UnitList, '')) = strcat(UnitList(strcmp(UnitList, '')), '(difference)');
end

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'UnitObj'
    if length(in)>1
        % Unit listing only on one junit at a time
        error([mfilename ': ' VarName ' must contain a single junit']);
    else
        % UnitObj is valid
        out = in;
    end % if
case 'option'
    if ~ischar(in) | (size(in, 1) ~= 1)
        error([mfilename ': ' VarName ' must contain a character string']);
    elseif ~strcmp(in, 'compatible')
        error([mfilename ': ' VarName ' is invalid']);
    else
        % listOption is valid
        out = in;
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch