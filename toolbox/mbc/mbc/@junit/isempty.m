function TrueFalse = isempty(UnitObj)
%ISEMPTY

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:32 $

%JUNIT/ISEMPTY  True for an a junit constructed with an empty string.
%   ISEMPTY(UnitObj) returns 1 if UnitObj is uninitialised (constructed with
%   an empty string) and 0 otherwise.
%
%   See also GET.

% ---------------------------------------------------------------------------
% Description : Method to test if a junit was a difference junit is
%               uninitialised (constructed with an empty string).
% Inputs      : UnitObj   - junit object (junit)
% Outputs     : TrueFalse - true or false (integer)
% ---------------------------------------------------------------------------

ReshapedUnitObj = UnitObj(:);
TrueFalse = zeros(size(ReshapedUnitObj));
for ucount = 1:length(ReshapedUnitObj),
    % Step through
    if ~isvalid(ReshapedUnitObj(ucount))
        TrueFalse(ucount) = 1;
    else
        TrueFalse(ucount) = isempty(ReshapedUnitObj(ucount).Constructor);
    end
end 
TrueFalse = reshape(TrueFalse, size(UnitObj));