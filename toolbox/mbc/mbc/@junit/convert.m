function ValuesOut = convert(UnitFrom, UnitTo, ValuesIn)
%CONVERT

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:24 $

%JUNIT/CONVERT  Unit conversion routine.
%
%   ValuesOut = CONVERT(UnitFrom, UnitTo, ValuesIn) converts ValuesIn in unit
%   UnitFrom to ValuesOut in unit UnitStrTo.
%
%   See also COMPATIBLE, INLINE, BASE.

% ---------------------------------------------------------------------------
% Description : Method to convert values from junit described by the object
%               UnitFrom to junit described by the object UnitTo.
% Inputs      : ValuesIn  - values to convert (double)
%               UnitFrom  - unit to convert from (junit)
%               UnitTo    - unit to convert to (junit)
% Outputs     : ValuesOut - converted values (double)
% ---------------------------------------------------------------------------

if ~isvalid(UnitFrom) | ~isvalid(UnitTo)
	ValuesOut= ValuesIn;
	return
end


% Import the ucar.unit package (must be on the MATLAB classpath)
import ucar.units.*;

% Error check on UnitA, UnitB
UnitFrom = i_check(UnitFrom, 'UnitFrom');
UnitTo   = i_check(UnitTo, 'UnitTo');
ValuesIn = i_check(ValuesIn, 'ValuesIn');

% If either junit is invalid, error
if ~isvalid(UnitFrom)
    error([mfilename ': invalid junit ' char(UnitFrom)]);
elseif ~isvalid(UnitTo)
    error([mfilename ': invalid junit ' char(UnitTo)]);
end

% Extract underlying Java objects
JavaUnitFrom = UnitFrom.Java;
JavaUnitTo   = UnitTo.Java;

% Reshape ValuesIn to a vector
ValuesInVector = ValuesIn(:);

if compatible(UnitFrom, UnitTo) == 1
    if (~isdifference(UnitFrom) & ~isdifference(UnitTo))
        % Convert non-OffsetUnit-s to the corresponding DerivedUnit-s (messy, bug in UCAR!)
        if ~isoffset(UnitFrom)&~isoffset(UnitTo)
            JavaUnitFrom = JavaUnitFrom.multiplyBy(JavaUnitFrom).divideBy(JavaUnitFrom);
            JavaUnitTo = JavaUnitTo.multiplyBy(JavaUnitTo).divideBy(JavaUnitTo);
        end
        % Units are compatible, perform conversion
        ValuesOutVector = JavaUnitFrom.convertTo(ValuesInVector, JavaUnitTo);
    elseif (isdifference(UnitFrom) & isdifference(UnitTo))
        UnitFrom.Difference = 0;
        UnitTo.Difference = 0;
        BaseUnitFromValues = convert(UnitFrom, base(UnitFrom), ValuesInVector) - ...
            convert(UnitFrom, base(UnitFrom), zeros(size(ValuesInVector)));
        ValuesOutVector = convert(base(UnitFrom), UnitTo, BaseUnitFromValues) - ...
            convert(base(UnitFrom), UnitTo, zeros(size(ValuesInVector)));
    else
        error([mfilename ': cannot convert between difference and nondifference units']);
    end % if
elseif compatible(UnitFrom, UnitTo) == -1
    % Units are reciprocal, perform conversion and send warning
    warning('units are reciprocal');
    UnitFromReciprocal = ...
        junit(['1/(' char(JavaUnitFrom.toString) ')']);
    JavaUnitFromReciprocal = UnitFromReciprocal.Java;
    ValuesOutVector = ...
        JavaUnitFromReciprocal.convertTo(1./ValuesInVector, JavaUnitTo);
else
    % Units are neither compatible nor reciprocal, send error
    error([mfilename ': unable to convert from ' ...
        char(JavaUnitFrom.getDerivedUnit.getQuantityDimension.toString) ...
        ' to ' char(JavaUnitTo.getDerivedUnit.getQuantityDimension.toString)]);
    return
end

% Reshape back
ValuesOut = reshape(ValuesOutVector, size(ValuesIn));

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case {'UnitFrom','UnitTo'}
    if ~isa(in, 'junit')
        % UnitFrom / UnitTo is not a junit
        error([mfilename ': ' VarName ' must be a junit']);
    elseif length(in)>1
        % Conversion works only on one pair of units at a time
        error([mfilename ': ' VarName ' must contain a single junit']);
    else
        % UnitFrom / UnitTo is valid
        out = in;
    end % if
case 'ValuesIn',
    if ~isnumeric(in)
        % ValuesIn is nonnumeric
        error([mfilename ': nonnumeric ' VarName]);
    elseif ~isreal(in)
        % ValuesIn is not real
        error([mfilename ': ' VarName ' must be real']);
    else
        % ValuesIn is valid
        out = in;
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch