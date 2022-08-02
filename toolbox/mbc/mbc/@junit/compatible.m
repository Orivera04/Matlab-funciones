function Flag = compatible(UnitA, UnitB)
%COMPATIBLE

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:23 $

%JUNIT/COMPATIBLE  Check if two units are compatible.
%
%   Flag = COMPATIBLE(UnitA, UnitB) checks if UnitA and UnitB are
%   compatible (returns 1), reciprocal (returns -1) or incompatible
%   (returns 0).
%
%   See also CONVERT, INLINE, BASE.

% ---------------------------------------------------------------------------
% Description : Method to check if junit-s Unit1 and Unit2 are compatible.
% Inputs      : UnitA - junit object (junit)
%               UnitB - junit object (junit)
% Outputs     : Flag  - compatible / reciprocal / incompatible flag (double)
% ---------------------------------------------------------------------------

% Error check on UnitA, UnitB
UnitA = i_check(UnitA, 'UnitA');
UnitB = i_check(UnitB, 'UnitB');

% If either junit is invalid, junit-s are not compatible
if (~isvalid(UnitA)) | (~isvalid(UnitB))
    Flag = 0;
    return
end

% If quantity type is defined for both units, use for preliminary
% compatibility check.  Otherwise, compatibility check will be based on
% dimensionality only.
if ~any(ismember(quantity(UnitA), quantity(UnitB)))
    Flag = 0;
    return
% Next check that difference flags are identical.    
elseif isdifference(UnitA) ~= isdifference(UnitB)
    Flag = 0;
    return
end

% Extract underlying Java objects
JavaUnitA = UnitA.Java;
JavaUnitB = UnitB.Java;

% Check compatibility using dimensionality
% WARNING: isCompatible returns true for compatible AND reciprocal units,
% therefore the order of the test is important!
if ((JavaUnitA.getDerivedUnit.isReciprocalOf(JavaUnitB.getDerivedUnit))&...
        ~JavaUnitA.isDimensionless)
    % (note: isReciprocal is only defined for DerivedUnitImpl)
    % Units are reciprocal
    Flag = -1;
elseif JavaUnitA.getDerivedUnit.isCompatible(JavaUnitB.getDerivedUnit)
    % Units are compatible
    Flag = 1;
% elseif JavaUnitA.getDerivedUnit.isReciprocalOf(JavaUnitB.getDerivedUnit)
else
    % Units are neither compatible nor reciprocal
    Flag = 0;
end

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case {'UnitA','UnitB'}
    if ~isa(in, 'junit')
        % UnitA / UnitB is not a junit
        error([mfilename ': ' VarName ' must be a junit']);
    elseif length(in)>1
        % Conversion works only on one pair of units at a time
        error([mfilename ': ' VarName ' must contain a single junit']);
    else
        % UnitA / UnitB is valid
        out = in;
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch