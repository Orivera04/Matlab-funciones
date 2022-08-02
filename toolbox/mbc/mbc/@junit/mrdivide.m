function UnitQuotient = mrdivide(UnitA, UnitB)
%MRDIVIDE

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:40 $

%JUNIT/MRDIVIDE  Calculates UnitQuotient = UnitA / UnitB.
%
%   UnitQuotient = MRDIVIDE(UnitA, UnitB) calculates
%   UnitProduct = UnitA * UnitB.
%
%   See also /, MTIMES, MPOWER.

% ---------------------------------------------------------------------------
% Description : Method to divide units UnitA by UnitB.
% Inputs      : UnitA        - junit object (junit)
%               UnitB        - junit object (junit)
% Outputs     : UnitQuotient - UnitA / UnitB (junit)
% ---------------------------------------------------------------------------




% Error check on UnitA, UnitB
UnitA = i_check(UnitA, 'UnitA');
UnitB = i_check(UnitB, 'UnitB');

if ~isvalid(UnitA) | ~isvalid(UnitB)
	UnitQuotient= UnitA;
	UnitQuotient = junit(['(',UnitA.Constructor,')/(',UnitB.Constructor,')']);
	return
end	

% If either junit is invalid, error
if ~isvalid(UnitA)
    error([mfilename ': invalid junit ' char(UnitA)]);
elseif ~isvalid(UnitB)
    error([mfilename ': invalid junit ' char(UnitB)]);
end

% Extract underlying Java objects
JavaUnitA = UnitA.Java;
JavaUnitB = UnitB.Java;

if (isoffset(UnitA) & ~isdifference(UnitA))
    warning(['dividing offset units may give unexpected results']);
end

% Divide Java objects
JavaUnitQuotient = JavaUnitA.divideBy(JavaUnitB);
% Construct the corresponding MATLAB object
UnitQuotient = displayname2junit(char(JavaUnitQuotient.toString));

% UnitQuotient inherits Difference from UnitA
UnitQuotient = set(UnitQuotient, 'Difference', isdifference(UnitA));

% UnitQuotient inherits Quantity from UnitA if UnitB is dimensionless
if isdimensionless(UnitB)
    UnitQuotient = set(UnitQuotient, 'Quantity', quantity(UnitA));
end

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case {'UnitA','UnitB'}
    if isnumeric(in)
        % Construct a junit our of UnitA / UnitB
        in = junit(num2str(in));
        out = i_check(in, VarName);
    elseif ~isa(in, 'junit')
        % UnitA / UnitB is not a junit
        error([mfilename ': ' VarName ' must be a junit']);
    elseif length(in)>1
        % Division works only on one pair of units at a time
        error([mfilename ': ' VarName ' must contain a single junit']);
    else
        % UnitFrom / UnitTo is valid
        out = in;
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch