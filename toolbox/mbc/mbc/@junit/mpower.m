function RaisedUnit = mpower(UnitObj, Exponent)
%MPOWER

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:39 $

%JUNIT/MPOWER  Calculates RaisedUnit = UnitObj^Exponent.
%
%   RaisedUnit = mpower(UnitObj, Exponent) calculates RaisedUnit = UnitObj^Exponent.
%
%   See also ^, MTIMES, MRDIVIDE.

% ---------------------------------------------------------------------------
% Description : Method to raise unit UnitObj to the power Exponent.
% Inputs      : UnitObj    - junit object (junit)
%               Exponent   - exponent (integer)
% Outputs     : RaisedUnit - UnitObj^Exponent (junit)
% ---------------------------------------------------------------------------

% Error check on UnitA, UnitB
UnitObj     = i_check(UnitObj, 'JUnit');
Exponent = i_check(Exponent, 'Exponent');

% If junit is invalid, error
if ~isvalid(UnitObj)
	RaisedUnit= UnitObj;
	RaisedUnit = junit(['(',RaisedUnit.Constructor,')^(',num2str(Exponent),')']);
	return
    % error([mfilename ': invalid junit ' char(UnitObj)]);
end

% Extract underlying Java objects
JavaUnit = UnitObj.Java;

% Check that the unit is not an offset unit, since these can't sensibly be
% raised to an exponent
if isoffset(UnitObj) & ~isdifference(UnitObj)
    warning('raising offset units to an exponent may give unexpected results');
end    

% Multiply Java objects
JavaRaisedUnit = JavaUnit.raiseTo(Exponent);

% Construct the corresponding MATLAB object
RaisedUnit = displayname2junit(char(JavaRaisedUnit.toString));

% BaseUnit inherits Difference from UnitObj
RaisedUnit = set(RaisedUnit, 'Difference', isdifference(UnitObj));

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'JUnit'
    if ~isa(in, 'junit')
        % Unit is not a junit
        error([mfilename ': ' VarName ' must be a junit']);
    elseif length(in)>1
        % Exponential works only on one pair of units at a time
        error([mfilename ': ' VarName ' must contain a single junit']);
    else
        % Unit is valid
        out = in;
    end % if
case 'Exponent'
    if ~isnumeric(in)
        % Exponent is nonnumeric
        error([mfilename ': ' VarName ' must be numeric']);
    elseif ~isreal(in)
        % Exponent is complex
        error([mfilename ': ' VarName ' must be real']);
    elseif length(in) ~= 1
        % Exponent is nonscalar
        error([mfilename ': ' VarName ' must be a scalar']);
    else
        % Exponent is valid when rounded to the nearest integer
        out = round(in);
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch