function BaseUnit = base(UnitObj)
%BASE

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:21 $

%JUNIT/BASE  Get properties of a junit object UnitObj.
%
%   BaseUnit = BASE(UnitObj) gets the base unit object from a junit object
%   UnitObj.
%
%   See also COMPATIBLE, CONVERT, INLINE.

% ---------------------------------------------------------------------------
% Description : Method to get properties of a junit object UnitObj.
% Inputs      : UnitObj  - junit object (junit)
% Outputs     : BaseUnit - base units object (junit)
% ---------------------------------------------------------------------------

% Error check on UnitObj
UnitObj = i_check(UnitObj, 'JUnit');

% If junit is invalid, return the junit
if ~isvalid(UnitObj)
    BaseUnit = UnitObj;
    return
end

% Extract underlying unit
JavaUnit = get(UnitObj, 'Java');

% Extract base unit
JavaBaseUnit = JavaUnit.getDerivedUnit;

if JavaBaseUnit.isDimensionless
    BaseUnit = junit('1');
else
    % Construct new unit from JavaBaseUnit
    BaseUnit = junit(deblank([char(JavaBaseUnit.toString)]));
end % if

% BaseUnit inherits Quantity and Difference from UnitObj
BaseUnit = set(BaseUnit, 'Quantity', quantity(UnitObj));
BaseUnit = set(BaseUnit, 'Difference', isdifference(UnitObj));

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'JUnit'
    if length(in)>1
        % Base unit conversion works only on one junit at a time
        error([mfilename ': ' VarName ' must contain a single junit']);
    else
        % UnitFrom / UnitTo is valid
        out = in;
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch