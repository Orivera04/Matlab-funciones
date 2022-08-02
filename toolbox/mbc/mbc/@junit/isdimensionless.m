function TrueFalse = isdimensionless(UnitObj)
%ISDIMENSIONLESS

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:31 $

%JUNIT/ISDIMENSIONLESS  True for a dimensionless junit.
%   ISDIMENSIONLESS(UnitObj) returns 1 if UnitObj is a dimensionless junit
%   and 0 otherwise.
%
%   See also GET.

% ---------------------------------------------------------------------------
% Description : Method to test if a junit is a dimensionless junit or not.
% Inputs      : UnitObj   - junit object (junit)
% Outputs     : TrueFalse - true or false (integer)
% ---------------------------------------------------------------------------

% Import the ucar.unit package (must be on the MATLAB classpath)
import ucar.units.*

ReshapedUnitObj = UnitObj(:);
TrueFalse = zeros(size(ReshapedUnitObj));
for ucount = 1:length(ReshapedUnitObj),
    % Step through
    if ~isvalid(ReshapedUnitObj(ucount))
        TrueFalse(ucount) = 0;
    else
        TrueFalse(ucount) = ReshapedUnitObj(ucount).Java.isDimensionless;
    end
end % if
TrueFalse = reshape(TrueFalse, size(UnitObj));