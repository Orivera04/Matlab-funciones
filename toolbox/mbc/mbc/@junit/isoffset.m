function TrueFalse = isoffset(UnitObj)
%ISOFFSET

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:33 $

%JUNIT/ISOFFSET  True for an offset junit.
%   ISOFFSET(UnitObj) returns 1 if UnitObj is an offset junit and 0
%   otherwise.
%
%   See also GET.

% ---------------------------------------------------------------------------
% Description : Method to test if a junit is an offset junit or not.
% Inputs      : UnitObj   - junit object (junit)
% Outputs     : TrueFalse - true or false (integer)
% ---------------------------------------------------------------------------

ReshapedUnitObj = UnitObj(:);
for ucount = 1:length(ReshapedUnitObj),
    % Step through
    if ~isvalid(ReshapedUnitObj(ucount))
        TrueFalse(ucount) = 0;
    else
        TrueFalse(ucount) = isa(ReshapedUnitObj(ucount).Java,'ucar.units.OffsetUnit');
    end
end % if
TrueFalse = reshape(TrueFalse, size(UnitObj));