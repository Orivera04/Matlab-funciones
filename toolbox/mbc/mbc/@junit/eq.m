function TrueFalse = eq(UnitA, UnitB)
%EQ

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:27 $

%JUNIT/EQ  Tests if two junit-s, UnitA and UnitB, are equal.
%
%   TrueFalse = EQ(UnitA, UnitB) tests if two junit-s, UnitA and UnitB
%   are equal.  Units are equal if their canonical string representations
%   are identical / their quotient is equivalent to 1 and if their quantity
%   types are compatible.
%
%   See also ==, NE.

% ---------------------------------------------------------------------------
% Description : Method to test if UnitA and UnitB are equal.
% Inputs      : UnitA     - junit object (junit)
%               UnitB     - junit object (junit)
% Outputs     : TrueFalse - UnitA == UnitB? (0 or 1)
% ---------------------------------------------------------------------------

% Error check on UnitA, UnitB
UnitA = i_check(UnitA, 'UnitA');
UnitB = i_check(UnitB, 'UnitB');

% Check that junit arrays are the same size
if all(size(UnitA) == size(UnitB))
    % Sizes are compatible
elseif length(UnitA) == 1
    UnitA = repmat(UnitA, size(UnitB));
elseif length(UnitB) == 1
    UnitB = repmat(UnitB, size(UnitA));
else
    error([mfilename ': junit arrays must be of the same size']);
end

ReshapedUnitA = UnitA(:);
ReshapedUnitB = UnitB(:);
for ucount = 1:length(ReshapedUnitA),
    lastwarn('');
    oldWarningStatus = warning('off');
    % Step through, test whether units are identical
    if (~isvalid(ReshapedUnitA(ucount))) | (~isvalid(ReshapedUnitB(ucount)))
        % One or both junit-s are invalid
        TrueFalse(ucount) = 0;
    else
        % Evaluate quotient, capture whether or not a warning was triggered
        UnitQuotient = ReshapedUnitA(ucount)/ReshapedUnitB(ucount);
        warning(oldWarningStatus)
        if ~any(ismember(quantity(ReshapedUnitA(ucount)), quantity(ReshapedUnitB(ucount))))
            % Quantity types are incompatible
            TrueFalse(ucount) = 0;
        elseif isdifference(ReshapedUnitA(ucount)) ~= isdifference(ReshapedUnitB(ucount))
            % Difference flags are not identical
            TrueFalse(ucount) = 0;
        elseif (strcmp(ReshapedUnitA(ucount).Java.toString, ...
                ReshapedUnitB(ucount).Java.toString))
            % Canonical string representations are identical, therefore units
            % are identical
            TrueFalse(ucount) = 1;
        elseif ~isempty(lastwarn)
            % A warning was triggered when evaluating the quotient, therefore
            % units are offset and it is not safe to return true
            warning('Testing the equality of offset units may give unexpected results');
            TrueFalse(ucount) = 0;
        elseif ~isdimensionless(UnitQuotient)
            % Units are of different dimensionality, so they are not equal
            TrueFalse(ucount) = 0;
        else
            % Units are identical if their quotient is 1
            TrueFalse(ucount) = (str2num(UnitQuotient.Java.toString) == 1);
        end
    end % if
end % for
warning(oldWarningStatus);
TrueFalse = reshape(TrueFalse, size(UnitA));


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
    else
        % UnitFrom / UnitTo is valid
        out = in;
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch