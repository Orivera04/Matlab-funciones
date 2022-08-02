function PREC = set(PREC, PropertyName, PropertyValue)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:43 $

%CGPREC/SET  Set properties of a cgprec object.
%
%   PREC = SET(PREC, PropertyName, PropertyValue) modifies the property
%   PropertyName of a cgprec object PREC to a value PropertyValue.
%
%   See also  CGPREC

% ---------------------------------------------------------------------------
% Description : Method to set properties of a cgprec object.
% Inputs      : PREC          - cgprec object
%               PropertyName  - property to be modified (str)
%               PropertyValue - modified property value
% Outputs     : PREC          - (modified) cgprec object
% ---------------------------------------------------------------------------

switch nargin,
case 3,
    % Try to use extra input as a property name if valid
    PropertyName = i_check(PropertyName, 'PropertyName');
    switch PropertyName
    case 'Name',
        % Set Name
        PREC.Name = PropertyValue;
    case 'Writable',
        % Set Writable
        PREC.Writable = PropertyValue;
    otherwise
        % Invalid property name
        error('Invalid property name.');
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
        % PropertyName is not a string, return empty
        out = '';
    else
        switch lower(in),
        case 'name',
            % Property name is Name
            out = 'Name';
        case 'writable',
            % Property name is Writable
            out = 'Writable';
        otherwise
            % Invalid property name, use default value
            out = '';
        end % switch
    end % if
end % switch