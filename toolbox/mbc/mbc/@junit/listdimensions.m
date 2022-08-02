function DimensionList = listdimensions(UnitObj, varargin)
%LISTDIMENSIONS

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:36 $

%JUNIT/LISTDIMENSIONS  List registered dimensions for the quantity type(s)
%   corresponding to a unit.
%
%   DimensionList = LISTDIMENSIONS(UnitObj) lists the registered
%   dimensions DimensionList for the quantity type(s) corresponding to a
%   unit UnitObj.
%
%   DimensionList = LISTDIMENSIONS(UnitObj, 'compatible') lists the
%   registered dimensions DimensionList for the quantity type(s) compatible
%   with a unit UnitObj.

% ---------------------------------------------------------------------------
% Description : Method to list registered dimensions for the quantity type(s)
%               corresponding to a unit.
% Inputs      : UnitObj        - unit (junit)
%               'compatible'   - optional switch
% Outputs     : DimensionList  - list of registered dimensions ({str})
% ---------------------------------------------------------------------------

% Error check on UnitObj
UnitObj = i_check(UnitObj, 'UnitObj');

% If junit is invalid, warn and return empty
if ~isvalid(UnitObj)
    warning(['invalid junit ' char(UnitObj)]);
    DimensionList = {};
    return
end

if nargin == 1
    % List dimensions
    DimensionList = listdimensions(quantity(UnitObj));
elseif nargin == 2
    % Error check on option
    option = i_check(varargin{1}, 'option');
    % List dimensions
    DimensionList = listdimensions(quantity(UnitObj, 'compatible'));
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