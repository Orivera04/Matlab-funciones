function UnitObj = saveobj(UnitObj)
%SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:53 $

%JUNIT/SAVEOBJ  Save a junit object UnitObj.
%
%   UnitObj = SAVEOBJ(UnitObj) saves a junit object UnitObj.
%
%   See also LOADOBJ.

% ---------------------------------------------------------------------------
% Description : Method to save a junit object UnitObj.
% Inputs      : UnitObj - junit object (junit)
% Outputs     : UnitObj - junit object (junit)
% ---------------------------------------------------------------------------

% Clear the Java junit object, save only the constructor and version
UnitObj.Java = [];