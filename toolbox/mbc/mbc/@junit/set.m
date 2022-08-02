function UnitObj = set(UnitObj, Property, Value)
%SET

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.3 $  $Date: 2004/02/09 06:43:54 $

%JUNIT/SET  Set properties of a junit object UnitObj.
%
%   Properties = SET(UnitObj) sets properties of a junit object UnitObj.
%
%   Properties = SET(UnitObj, Property) gets a specific property of UnitObj.
%   The following Property-s are valid: 'Difference', 'Quantity'.
%
%   See also GET.

% ---------------------------------------------------------------------------
% Description : Method to set properties of a junit object UnitObj.
% Inputs      : UnitObj  - junit object (junit)
%               Property - property name (string)
%               Value    - property value (various)
% Outputs     : UnitObj  - updated junit object (junit)
% ---------------------------------------------------------------------------

switch nargin,
case 3,
    if length(UnitObj)~=1
        error([mfilename ': ' inputname(1) ' must contain a single junit']);
    else
        Property = i_check(Property, 'Property');
        switch Property,
        case 'Difference',
            UnitObj.Difference = i_check(Value, 'Difference');
        case 'Quantity',
            UnitObj.Quantity = i_check(Value, 'Quantity', UnitObj);
        end % switch
    end % if
otherwise,
    error([mfilename ': invalid number of arguments']);
end % switch

% ---------------------------------------------------------------------------

function out = i_check(in, VarName, varargin)

% Check input variables

% Import the ucar.unit package (must be on the MATLAB classpath)
import ucar.units.*

switch VarName,
case 'Property',
    if ~ischar(in)
        % Property is not a string
        error([mfilename ': invalid ' VarName]);
    else
        switch lower(in),
        case 'quantity',
            % Property name is Quantity
            out = 'Quantity';
        case 'difference',
            % Property name is Difference
            out = 'Difference';
        end % switch
    end % if
case 'Difference',
    if ~isnumeric(in)
        % Property is not numeric
        error([mfilename ': ' VarName ' must be 0 or 1']);
    elseif length(in)~=1
        % Property is not a single number
        error([mfilename ': ' VarName ' must be 0 or 1']);
    else
        out = (in~=0);
    end % if
case 'Quantity',
    UnitObj = varargin{1};
    if ~isvalid(UnitObj)
        warning(['invalid junit ' char(UnitObj)]);
        out = {};
        return
    end
    % Put the contents of Quantity in a 1 x n cell array of strings
    if ~iscell(in)
        in = {in};
    end % if
    Quantity = in(:)';
    % Step through the elements of Quantity, checking for non-strings and
    % removing empty cells
    for qcount = length(in):-1:1,
        if isempty(Quantity{qcount})
            % This element is empty, remove it from the cell array
            Quantity(qcount) = [];
        elseif ~ischar(Quantity{qcount})
            % This element is not a character array, error
            error([mfilename ': ' VarName ' must contain string(s)']);
        else
            % This element is valid, retain only the first row
            Quantity{qcount} = Quantity{qcount}(1,:);
        end % if
    end % for
    ValidQuantities = quantity(displayname2junit(char(UnitObj.Java.toString)));
    if ~all(ismember(in, ValidQuantities))
        error([mfilename ': invalid quantity type for unit ' char(UnitObj)]);
    else
        out = in;
    end
end % switch        
