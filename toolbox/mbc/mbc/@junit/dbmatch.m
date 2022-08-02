function MatchedUnitObj = dbmatch(UnitObj)
%DBMATCH

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:25 $

%JUNIT/DBMATCH  Returns units in the database that are equal to a junit.
%
%   MatchedUnitObj = DBMATCH(UnitObj) returns units in the database that are
%   equal to a junit UnitObj.

% ---------------------------------------------------------------------------
% Description : Method to list registered dimensions for a quantity type
%               corresponding to a unit.
% Inputs      : UnitObj        - unit (junit)
% Outputs     : MatchedUnitObj - equal units (junit)
% ---------------------------------------------------------------------------

% Error check on UnitObj
UnitObj = i_check(UnitObj, 'UnitObj');

% Check if the unit is in the database
if ~isvalid(UnitObj)
    % Unit is invalid, nothing can be done
    MatchedUnitObj = UnitObj;
elseif isempty(UnitObj.Java.getUnitName)
    % Unit is not in the database
    compatibleUnits = listunits(UnitObj);
    if isempty(compatibleUnits)
        % No compatible units are in the database, return the original unit
        MatchedUnitObj = UnitObj;
        return
    end
    % Step through compatible units to find out if any is equal
    for cuc = 1:length(compatibleUnits)
        compatibleUnitsEqual(cuc) = (displayname2junit(compatibleUnits{cuc}) == UnitObj);
    end
    % Generate a cell array of the displaynames of equal units
    MatchedUnitStr = compatibleUnits(compatibleUnitsEqual);
    if length(MatchedUnitStr) == 0
        % If no equal unit was found, return the input unit
        MatchedUnitObj = UnitObj;
    else
        % Create an array of equal junit-s from the displaynames
        for muc = 1:length(MatchedUnitStr)
            MatchedUnitObj(muc) = displayname2junit(MatchedUnitStr{muc});
            MatchedUnitObj(muc) = set(MatchedUnitObj(muc), ...
                'Quantity', intersect(quantity(UnitObj), quantity(MatchedUnitObj(muc))));
        end
    end
else
    % Unit is in the database
    MatchedUnitObj = UnitObj;
end

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'UnitObj'
    if ~isa(in, 'junit')
        % UnitObj is not a junit
        error([mfilename ': ' VarName ' must be a junit']);
    elseif length(in)>1
        % Matching works only on one pair of units at a time
        error([mfilename ': ' VarName ' must contain a single junit']);
    else
        % UnitObj is valid
        out = in;
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch