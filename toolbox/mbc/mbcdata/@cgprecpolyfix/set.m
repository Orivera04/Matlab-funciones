function POLYFIXPREC = set(POLYFIXPREC, PropertyName, PropertyValue)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:16 $

%CGPRECPOLYFIX/SET  Set properties of a cgprecpolyfix object.
%
%   POLYFIXPREC = SET(POLYFIXPREC, PropertyName, PropertyValue)
%   modifies the property PropertyName of a cgprecpolyfix object
%   POLYFIXPREC to a value PropertyValue.
%
%   See also  CGPRECPOLYFIX

% ---------------------------------------------------------------------------
% Description : Method to set properties of a cgprecpolyfix object.
% Inputs      : POLYFIXPREC   - cgprecpolyfix object
%               PropertyName  - property to be modified (str)
%               PropertyValue - modified property value
% Outputs     : POLYFIXPREC   - (modified) cgprecpolyfix object
% ---------------------------------------------------------------------------

switch nargin,
case 3,
    % Try to use extra input as a property name if valid
    PropertyName = i_check(PropertyName, 'PropertyName');
    switch PropertyName
    case 'NumCoeff',
        % Set NumCoeff
        POLYFIXPREC.NumCoeff = PropertyValue;
    case 'DenCoeff',
        % Set DenCoeff
        POLYFIXPREC.DenCoeff = PropertyValue;
    case 'PhysRange',
        % Set PhysRange
        POLYFIXPREC.PhysRange = PropertyValue;
    otherwise
        % No valid property name at this level, try the superclass
        POLYFIXPREC.cgprecfix = ...
            set(POLYFIXPREC.cgprecfix, PropertyName, PropertyValue);
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
        case 'numcoeff',
            % Property name is NumCoeff
            out = 'NumCoeff';
        case 'dencoeff',
            % Property name is DenCoeff
            out = 'DenCoeff';
        case 'physrange',
            % Property name is PhysRange
            out = 'PhysRange';
        otherwise
            % PropertyName is not defined at this level
            out = in;
        end % switch
    end % if
end % switch