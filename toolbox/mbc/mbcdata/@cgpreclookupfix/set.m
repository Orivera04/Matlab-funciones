function LOOKUPFIXPREC = set(LOOKUPFIXPREC, PropertyName, PropertyValue)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:08 $

%CGPRECLOOKUPFIX/SET  Set properties of a cgpreclookupfix object.
%
%   LOOKUPFIXPREC = SET(LOOKUPFIXPREC, PropertyName, PropertyValue)
%   modifies the property PropertyName of a cgpreclookupfix object
%   LOOKUPFIXPREC to a value PropertyValue.
%
%   See also  CGPRECLOOKUPFIX

% ---------------------------------------------------------------------------
% Description : Method to set properties of a cgpreclookupfix object.
% Inputs      : LOOKUPFIXPREC - original cgpreclookupfix object
%               PropertyName  - property to be modified (str)
%               PropertyValue - modified property value
% Outputs     : LOOKUPFIXPREC - modified cgpreclookupfix object
% ---------------------------------------------------------------------------

switch nargin,
case 3,
    % Try to use extra input as a property name if valid
    PropertyName = i_check(PropertyName, 'PropertyName');
    switch PropertyName
    case 'TablePhysData',
        % Set TablePhysData
        LOOKUPFIXPREC.TablePhysData = PropertyValue;
    case 'TableHWData',
        % Set TableHWData
        LOOKUPFIXPREC.TableHWData = PropertyValue;
    case 'PhysRange',
        % Set PhysRange
        LOOKUPFIXPREC.PhysRange = PropertyValue;
    otherwise
        % No valid property name at this level, try the superclass
        LOOKUPFIXPREC.cgprecfix = ...
            set(LOOKUPFIXPREC.cgprecfix, PropertyName, PropertyValue);
    end % switch
otherwise
    % Incorrect number of input arguments
    error('Incorrect number of input arguments.');
end % switch

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'PropertyName',
    if ~ischar(in)
        % PropertyName is not a string
        out = in;
    else
        switch lower(in),
        case 'tablephysdata',
            % Property name is TablePhysData
            out = 'TablePhysData';
        case 'tablehwdata',
            % Property name is TableHWData
            out = 'TableHWData';
        case 'physrange',
            % Property name is PhysRange
            out = 'PhysRange';
        otherwise
            % PropertyName is not defined at this level
            out = in;
        end % switch
    end % if
end % switch