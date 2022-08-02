function QuantityList = quantity(UnitObj, varargin)
%QUANTITY

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:52 $

%JUNIT/QUANTITY  List registered quantity types for a junit.
%
%   QuantityList = QUANTITY(UnitObj) lists the registered quantity types of a junit
%   UnitObj.
%
%   QuantityList = QUANTITY(UnitObj, 'compatible') lists the registered quantity 
%   types of junit-s compatible with UnitObj.
%
%   See also GET.

% ---------------------------------------------------------------------------
% Description : Method to list registered quantity types for a junit.
% Inputs      : UnitObj      - junit object (junit)
%               QueryType    - query type (string, optional)
% Outputs     : QuantityList - registered quantity types (Cell)
% ---------------------------------------------------------------------------

% Import the ucar.unit package (must be on the MATLAB classpath)
import ucar.units.*;

% Error check on UnitObj
UnitObj = i_check(UnitObj, 'JUnit');

% If junit is invalid, warn and return empty
if ~isvalid(UnitObj)
    warning(['invalid junit ' char(UnitObj)]);
    QuantityList = {};
    return
end

% Extract underlying Java object
JavaUnit = UnitObj.Java;

QT=0;
switch nargin,
case 1,
    if ~isempty(UnitObj.Quantity)
        QuantityList = UnitObj.Quantity;
    else
        % Quantity has not been specified, so all registered quantity types
        % are valid
        QuantityVector = QuantityType.getQuantityTypes(JavaUnit);
        QuantityList = i_vector2cell(QuantityVector);
    end % if
otherwise,
    QueryType = i_check(varargin{1}, 'QueryType');
    if strcmp(QueryType, 'compatible')
        % Get dimension
        JavaUnitDim = JavaUnit.getDerivedUnit.getQuantityDimension;
        % Look up quantity types for compatible units
        QuantityVector = QuantityType.getQuantityTypes(JavaUnitDim);
        QuantityList = i_vector2cell(QuantityVector);
		  
		  QT=1;
    else
        % Look up quantity types for UnitObj
        QuantityVector = QuantityType.getQuantityTypes(JavaUnit);
        QuantityList = i_vector2cell(QuantityVector);
    end
end % switch

% If no quantity types are registered, then the unit is not registered and
% all compatible quantity types are returned
if isempty(QuantityList) & ~QT
    QuantityList = quantity(UnitObj, 'compatible');
end

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'JUnit'
    if length(in)>1
        % Quantity type lookup works only on one junit at a time
        error([mfilename ': ' VarName ' must contain a single junit']);
    else
        % UnitFrom / UnitTo is valid
        out = in;
    end % if
case 'QueryType',
    if ~ischar(in)
        % Property is not a string, use default value
        out = '';
    else
        switch lower(in),
        case 'compatible',
            % QueryType is compatible
            out = 'compatible';
        otherwise
            % Invalid property name, use default value
            out = '';
        end % switch
    end % if
otherwise
    warning(['variable check is not defined for ' VarName]);
    out = in;
end % switch

% ---------------------------------------------------------------------------
function cellout = i_vector2cell(vectorin)

% Convert from java.lang.vector to MATLAB cell 

% Load into a cell array
if isempty(vectorin)
    cellout = {};
else
    cellout = {}; % initialise
    for rcount = 0:(vectorin.size)-1,
        cellout = [cellout {vectorin.elementAt(rcount)}];
    end % for
end % if