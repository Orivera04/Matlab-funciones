function UnitChar = char(UnitObj, varargin)
%CHAR

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:22 $

%JUNIT/CHAR  Display a human-readable representation of a junit object
%   UnitObj.
%
%   CHAR(UnitObj) displays a human-readable representation of a junit object.
%
%   CHAR(UnitObj, InvalidFlag) appends a flag InvalidFlag to indicate when
%   a junit is invalid.
%
%   See also DISPLAY.

% ---------------------------------------------------------------------------
% Description : Method to display a junit object
% Inputs      : UnitObj - junit object (junit)
% Outputs     : UnitChar - human-readable representation (string)
% ---------------------------------------------------------------------------

if nargin == 2
    InvalidFlag = i_check(varargin{1}, 'InvalidFlag');
else
    InvalidFlag = '';
end

if length(UnitObj)==1
    % Display the String representation of the underlying Java object
    if isvalid(UnitObj)
        UnitChar = i_tidy(UnitObj.Java);
    else
        UnitChar = [UnitObj.Constructor InvalidFlag];
    end
    if isdifference(UnitObj)
        UnitChar = strtrim([UnitChar ' (difference)']);
    end
else
    % Display an array of unit-s in a cell array of strings
    UnitDisplay = {};
    ReshapedUnit = UnitObj(:);
    for ucount = 1:length(ReshapedUnit),
        ThisUnit = ReshapedUnit(ucount);
        % Display the String representation of the underlying Java object
        % and add it to the UnitDisplay cell array
        if isvalid(ReshapedUnit(ucount))
            UnitDisplay{ucount} = i_tidy(ThisUnit.Java);
        else
            UnitDisplay{ucount} = [UnitObj(ucount).Constructor InvalidFlag];
        end
        if isdifference(ReshapedUnit(ucount))
            UnitDisplay{ucount} = strtrim([UnitDisplay{ucount} ' (difference)']);
        end
    end % for
    % Reshape UnitDisplay to be the same shape as UnitObj
    UnitDisplay = reshape(UnitDisplay, size(UnitObj));
    UnitChar = UnitDisplay;
end % if

% ---------------------------------------------------------------------------

function tidyString = i_tidy(JavaUnit)

% Tidy up scaling factors for ScaledUnit-s
if isa(JavaUnit, 'ucar.units.ScaledUnit') & isempty(JavaUnit.getUnitName)
    JavaUnitScale = double(JavaUnit.getScale);
    JavaUnitUnit = char(JavaUnit.getUnit.toString);
    if abs(JavaUnitScale-1) < 2*eps
        % Scaling factor is 1, trim
        tidyString = JavaUnitUnit;
    else
        tidyString = deblank([num2str(JavaUnitScale) ' ' JavaUnitUnit]);
    end
else
    % Use toString method to get string representation of Java unit
    tidyString = deblank(char(JavaUnit.toString));
end

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'InvalidFlag'
    if ~ischar(in)
        % InvalidFlag is not a string
        error([mfilename ': ' VarName ' must be a string']);
    elseif size(in,1)~=1
        % InvalidFlag is an array of strings
        error([mfilename ': ' VarName ' must be a single string']);
    else
        % InvalidFlag is valid
        out = in;
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch

% ---------------------------------------------------------------------------

function strOut = strtrim(strIn)

strOut = deblank(strIn);
strOut = fliplr(strOut);
strOut = deblank(strOut);
strOut = fliplr(strOut);
