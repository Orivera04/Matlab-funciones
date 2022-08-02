function ConversionRule = inline(UnitFrom, UnitTo)
%INLINE

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:29 $

%JUNIT/INLINE  Construct an inline function object for a junit conversion
%   rule.
%
%   ConversionRule = INLINE(UnitFrom, UnitTo) constructs an inline function
%   object for a junit conversion rule from UnitFrom to UnitTo.
%
%   See also COMPATIBLE, CONVERT, BASE.

% ---------------------------------------------------------------------------
% Description : Method to construct an inline function object for a junit
%               conversion rule from UnitFrom to UnitTo.
% Inputs      : UnitFrom       - junit object to convert from (junit)
%               UnitTo         - junit object to convert to (junit)
% Outputs     : ConversionRule - conversion rule (inline)
% ---------------------------------------------------------------------------

% Error check on UnitA, UnitB
UnitFrom = i_check(UnitFrom, 'UnitFrom');
UnitTo   = i_check(UnitTo, 'UnitTo');

% If either junit is invalid, error
if ~isvalid(UnitFrom)
    error([mfilename ': invalid junit ' char(UnitFrom)]);
elseif ~isvalid(UnitTo)
    error([mfilename ': invalid junit ' char(UnitTo)]);
end

% Extract underlying Java objects
JavaUnitFrom = UnitFrom.Java;
JavaUnitTo   = UnitTo.Java;

if compatible(UnitFrom, UnitTo)==1
    % Units are compatible, find gradient and intercept of the conversion
    % rule by evaluating the conversion at two points
    samplePoints = convert(UnitFrom, UnitTo, [0 1]);
    gradient = diff(samplePoints);
    intercept = samplePoints(1);
    % ConversionRule = inline([num2str(gradient) '*x + ' num2str(intercept)],'x');
    ConversionRule = inline([sprintf('%.15g',gradient) '*x + ' sprintf('%.15g',intercept)],'x');
elseif compatible(UnitFrom, UnitTo)==-1
    % Units are incompatible, find gradient of the conversion rule by
    % evaluating the conversion at one point
    gradient = convert(UnitFrom,UnitTo,1);
    ConversionRule = inline([sprintf('%.15g',gradient) './x'],'x');
else
    % Units are incompatible, error
    error([mfilename ': unable to convert from ' ...
        char(JavaUnitFrom.getDerivedUnit.getQuantityDimension.toString) ...
        ' to ' char(JavaUnitTo.getDerivedUnit.getQuantityDimension.toString)]);
end

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
    elseif ~isvalid(in)
        out = in;
    else
        if in.Java.isDimensionless
            % convertTo method doesn't like dimensionless units
            out = 1*in;
        else
            % UnitFrom / UnitTo is valid
            out = in;
        end % if
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch