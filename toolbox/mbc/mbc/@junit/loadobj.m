function UnitObj = loadobj(UnitObj)
%LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc.
%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 06:43:38 $



%JUNIT/LOADOBJ  Load a junit object Unit.
%
%   UnitObj = LOADOBJ(UnitObj) loads a junit object UnitObj.
%
%   See also SAVEOBJ.

% ---------------------------------------------------------------------------
% Description : Method to load a junit object UnitObj.
% Inputs      : UnitObj - junit object (junit)
% Outputs     : UnitObj - junit object (junit)
% ---------------------------------------------------------------------------

if isstruct(UnitObj)
	UnitObj= i_Update(UnitObj);
	% Recreate the Java junit object from the constructor
	UnitObj = junit(UnitObj);
elseif UnitObj.IsValid
	UnitObj.IsValid= false;
end





% Recreate the Java junit object from the constructor
% RecreatedUnit = junit(UnitObj);


function UnitObj= i_Update(UnitObj);

% force the constructor here
UnitObj.IsValid= true;
UnitObj.JUnitVer=2;


