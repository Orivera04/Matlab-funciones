function TrueFalse = isdifference(UnitObj)
%ISDIFFERENCE

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:30 $

%JUNIT/ISDIFFERENCE  True for a difference junit.
%   ISDIFFERENCE(UnitObj) returns 1 if UnitObj is a difference junit and 0
%   otherwise.
%
%   See also GET.

% ---------------------------------------------------------------------------
% Description : Method to test if a junit is a difference junit or not.
% Inputs      : UnitObj   - junit object (junit)
% Outputs     : TrueFalse - true or false (integer)
% ---------------------------------------------------------------------------

ReshapedUnitObj = UnitObj(:);
TrueFalse = zeros(size(ReshapedUnitObj));
for ucount = 1:length(ReshapedUnitObj),
    % Step through
    if ~isvalid(ReshapedUnitObj(ucount))
        TrueFalse(ucount) = 0;
    else
        TrueFalse(ucount) = ReshapedUnitObj(ucount).Difference;
    end
end % if
TrueFalse = reshape(TrueFalse, size(UnitObj));