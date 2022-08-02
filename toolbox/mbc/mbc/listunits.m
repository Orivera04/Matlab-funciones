function UnitList = listunits(QuantityString)
%LISTUNITS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:48:33 $

%LISTUNITS  List registered units for one or more quantity types.
%
%   DimensionList = LISTUNITS(QuantityString) lists the registered units
%   of one or more quantity types.

% ---------------------------------------------------------------------------
% Description : Method to list registered units for a quantity type.
% Inputs      : QuantityString - string(s) to construct QuantityType
%                                object(s) (str / {str})
% Outputs     : UnitList       - list of string representations of registered
%                                units ({str})
% ---------------------------------------------------------------------------

% Import the ucar.unit package (must be on the MATLAB classpath)
import ucar.units.*;

if ~iscell(QuantityString)
    QuantityString = {QuantityString};
end

UnitList = {}; % initialise

% Step through quantity types
for qcount = 1:length(QuantityString)    
    
    % Error check on QuantityString
    thisQuantityString = i_check(QuantityString{qcount}, 'QuantityString');
    
    % Construct a QuantityType object from the string
    QT = QuantityType(thisQuantityString);
    
    % Look up units
    UnitListVector = QuantityType.getUnits(QT);

    if ~isempty(UnitListVector)
        % Step through units
        for ucount = 0:double(UnitListVector.size-1)
            thisJUnit = char(UnitListVector.elementAt(ucount));
            % Add to the list
            if isempty(UnitList)
                UnitList = {thisJUnit};
            elseif isempty(strmatch(thisJUnit, UnitList))
                UnitList{end+1} = thisJUnit;
            end
        end
    end
        
end

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'QuantityString'
    if ~ischar(in)
        % QuantityString is not a string
        error([mfilename ': ' VarName ' must be a string']);
    elseif size(in,1)~=1
        % QuantityString is an array of strings
        error([mfilename ': ' VarName ' must be a single string']);
    else
        % QuantityString is valid
        out = in;
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch