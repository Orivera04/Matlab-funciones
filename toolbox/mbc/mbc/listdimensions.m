function DimensionList = listdimensions(QuantityString)
%LISTDIMENSIONS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:48:31 $

%LISTDIMENSIONS  List registered dimensions for a quantity type.
%
%   DimensionList = LISTDIMENSIONS(QuantityString) lists the registered
%   dimensions of a quantity type.

% ---------------------------------------------------------------------------
% Description : Method to list registered dimensions for a quantity type.
% Inputs      : QuantityString - string(s) to construct QuantityType object
%               (str / {str})
% Outputs     : DimensionList  - list of registered dimensions ({str})
% ---------------------------------------------------------------------------

% Import the ucar.unit package (must be on the MATLAB classpath)
import ucar.units.*;

if ~iscell(QuantityString)
    QuantityString = {QuantityString};
end

DimensionList = {}; % initialise

% Step through quantity types
for qcount = 1:length(QuantityString)    
    
    % Error check on Unit
    thisQuantityString = i_check(QuantityString{qcount}, 'QuantityString');
    
    % Construct a QuantityType object from the string
    QT = QuantityType(thisQuantityString);
    
    % Look up dimensions
    DimensionListVector = QuantityType.getQuantityDimensions(QT);
    
    if ~isempty(DimensionListVector)
        % Step through dimensions
        for dcount = 0:double(DimensionListVector.size-1)
            thisDimension = char(DimensionListVector.elementAt(dcount));
            % Add to the list
            if isempty(DimensionList)
                DimensionList = {thisDimension};
            elseif isempty(strmatch(thisDimension, DimensionList))
                DimensionList{end+1} = thisDimension;
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