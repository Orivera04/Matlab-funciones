function POLYFIXPRECProperty = get(POLYFIXPREC, varargin)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:11 $

%CGPRECPOLYFIX/GET  Get properties of a cgprecpolyfix object.
%
%   POLYFIXPRECProperty = GET(POLYFIXPREC, Property) returns the specified
%   property Property of the cgprecpolyfix object POLYFIXPREC.
%
%   POLYFIXPRECProperty = GET(POLYFIXPREC) returns all available properties
%   of the cgprecpolyfix object.
%
%   See also  CGPRECPOLYFIX

% ---------------------------------------------------------------------------
% Description : Method to get properties of a cgprecpolyfix object
%               POLYFIXPREC.
% Inputs      : POLYFIXPREC         - cgprecpolyfix object specifying
%                                     the polynomial-based mapping from
%                                     physical values to hardware values and
%                                     the admissible physical range
% Opt inputs  : Property            - cgprecpolyfix object property name
%                                     (char)
% Outputs     : POLYFIXPRECProperty - property value (cell/dbl)
% ---------------------------------------------------------------------------

switch nargin,
case 1,
    % Return all available properties in a cell array
    POLYFIXPRECProperty           = get(POLYFIXPREC.cgprecfix);
    POLYFIXPRECProperty.NumCoeff  = POLYFIXPREC.NumCoeff;
    POLYFIXPRECProperty.DenCoeff  = POLYFIXPREC.DenCoeff;
    POLYFIXPRECProperty.PhysRange = POLYFIXPREC.PhysRange;
otherwise,
    % Try to use extra input as a property name if valid
    Property = i_check(varargin{1}, 'Property');
    switch Property
    case 'NumCoeff',
        % Return NumCoeff
        POLYFIXPRECProperty = POLYFIXPREC.NumCoeff;
    case 'DenCoeff',
        % Return DenCoeff
        POLYFIXPRECProperty = POLYFIXPREC.DenCoeff;
    case 'PhysRange',
        % Return PhysRange
        POLYFIXPRECProperty = POLYFIXPREC.PhysRange;
    otherwise
        if ~isempty(get(POLYFIXPREC.cgprecfix, varargin{1}))
            % Property was defined in the parent, get data from there
            POLYFIXPRECProperty = get(POLYFIXPREC.cgprecfix, varargin{1});
        else
            % Invalid property name, return empty
            POLYFIXPRECProperty = [];
        end % if
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
            % Invalid property name, use default value
            out = '';
        end % switch
    end % if
end % switch