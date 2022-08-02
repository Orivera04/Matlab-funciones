function TrueFalse = isvalid(UnitObj)
%ISVALID

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:34 $

%JUNIT/ISVALID  True for a difference junit.
%   ISVALID(UnitObj) returns 1 if UnitObj is a valid junit and 0 otherwise.
%
%   See also GET.

% ---------------------------------------------------------------------------
% Description : Method to test if a junit is valid.
% Inputs      : UnitObj   - junit object (junit)
% Outputs     : TrueFalse - true or false (integer)
% ---------------------------------------------------------------------------

if numel(UnitObj)==1
	TrueFalse = UnitObj.IsValid;
else
	ReshapedUnitObj = UnitObj(:);
	TrueFalse = zeros(size(ReshapedUnitObj));
	for ucount = 1:length(ReshapedUnitObj),
		% Step through
		TrueFalse(ucount) = UnitObj(ucount).IsValid;
	end % if
	TrueFalse = reshape(TrueFalse, size(UnitObj));
end