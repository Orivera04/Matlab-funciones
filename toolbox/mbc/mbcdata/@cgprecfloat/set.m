function FLOATPREC = set(FLOATPREC, PropertyName, PropertyValue)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:00 $

%CGPRECFLOAT/SET  Set properties of a cgprecfloat object.
%
%   FLOATPREC = SET(FLOATPREC, PropertyName, PropertyValue) modifies the
%   property PropertyName of a cgprecfloat object FLOATPREC to a value
%   PropertyValue.
%
%   See also  CGPRECFLOAT

% ---------------------------------------------------------------------------
% Description : Method to set properties of a cgprecfloat object.
% Inputs      : FLOATPREC     - cgprecfloat object
%               PropertyName  - property to be modified (str)
%               PropertyValue - modified property value
% Outputs     : FLOATPREC     - (modified) cgprecfloat object
% ---------------------------------------------------------------------------

switch nargin,
case 3,
    % Try to use extra input as a property name if valid
    PropertyName = i_check(PropertyName, 'PropertyName');
    switch PropertyName
    case 'mbits',
        % Set mbits
        FLOATPREC.mbits = PropertyValue;
    case 'ebits',
        % Set ebits
        FLOATPREC.ebits = PropertyValue;
    case 'PhysRange',
        % Set PhysRange
        FLOATPREC.PhysRange = PropertyValue;
    otherwise
        % No valid property name at this level, try the superclass
        FLOATPREC.cgprec = ...
            set(FLOATPREC.cgprec, PropertyName, PropertyValue);
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
        case 'mbits',
            % Property name is mbits
            out = 'mbits';
        case 'ebits',
            % Property name is ebits
            out = 'ebits';
        case 'physrange',
            % Property name is PhysRange
            out = 'PhysRange';
        otherwise
            % PropertyName is not defined at this level
            out = in;
        end % switch
    end % if
end % switch