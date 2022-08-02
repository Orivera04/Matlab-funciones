function PRECProperty = get(PREC, varargin)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:42 $

%CGPREC/GET  Get properties of a cgprec object.
%
%   PRECProperty = GET(PREC) returns the properties of the cgprec object
%   PREC.
%
%   See also  CGPREC, CGPRECFLOAT, FIXEDPRECISION

% ---------------------------------------------------------------------------
% Description : Method to get properties of a cgprec object PREC.
% Inputs      : PREC         - cgprec object
% Outputs     : PrecProperty - property value (cell/str)
% ---------------------------------------------------------------------------

switch nargin,
case 1,
    % Return all available properties in a cell array
    PRECProperty.Name     = PREC.Name;
    PRECProperty.Writable = PREC.Writable;
otherwise,
    % Try to use extra input as a property name if valid
    Property = i_check(varargin{1}, 'Property');
    switch Property
    case 'Name',
        % Return Name
        PRECProperty = PREC.Name;
    case 'Writable',
        % Return Writable
        PRECProperty = PREC.Writable;
    otherwise
        % Invalid property name, return empty
        PRECProperty = [];
    end % if
end % switch

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'Property',
    if ~ischar(in)
        % Property is not a string, use default value
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