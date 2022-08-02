function UnitProduct = mtimes(UnitA, UnitB)
%MTIMES

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:41 $

%JUNIT/MTIMES  Calculates UnitProduct = UnitA * UnitB.
%
%   UnitProduct = MTIMES(UnitA, UnitB) calculates UnitProduct = UnitA * UnitB.
%
%   See also *, MRDIVIDE, MPOWER.

% ---------------------------------------------------------------------------
% Description : Method to multiply units UnitA and UnitB.
% Inputs      : UnitA       - junit object (junit)
%               UnitB       - junit object (junit)
% Outputs     : UnitProduct - UnitA * UnitB (junit)
% ---------------------------------------------------------------------------

% Error check on UnitA, UnitB
UnitA = i_check(UnitA, 'UnitA');
UnitB = i_check(UnitB, 'UnitB');

if ~isvalid(UnitA) | ~isvalid(UnitB)
	UnitProduct= UnitA;
	UnitProduct = junit([UnitA.Constructor,'*',UnitB.Constructor]);
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

% Check that the units are not offset units, since these can't sensibly be
% multiplied
if (isoffset(UnitA) & ~isdifference(UnitA)) | ...
   (isoffset(UnitB) & ~isdifference(UnitB))
    warning('multiplying offset units may give unexpected results');
end    

% Multiply Java objects
JavaUnitProduct = JavaUnitA.multiplyBy(JavaUnitB);

% Construct the corresponding MATLAB object
UnitProduct = displayname2junit(char(JavaUnitProduct.toString));

% UnitProduct inherits Difference and Quantity from UnitA if UnitB is
% dimensionless and vice versa
if (isdimensionless(UnitA))&(~isdimensionless(UnitB))
    UnitProduct = set(UnitProduct, 'Quantity', quantity(UnitB));
    UnitProduct = set(UnitProduct, 'Difference', isdifference(UnitB));
elseif (~isdimensionless(UnitA))&(isdimensionless(UnitB))
    UnitProduct = set(UnitProduct, 'Quantity', quantity(UnitA));
    UnitProduct = set(UnitProduct, 'Difference', isdifference(UnitA));
elseif (isdimensionless(UnitA))&(isdimensionless(UnitB))
    UnitProduct = set(UnitProduct, 'Difference', any([isdifference(UnitA) isdifference(UnitB)]));
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
        % Multiplication works only on one pair of units at a time
        error([mfilename ': ' VarName ' must contain a single junit']);
    else
        % UnitFrom / UnitTo is valid
        out = in;
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch