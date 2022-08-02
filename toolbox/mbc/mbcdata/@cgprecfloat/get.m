function FLOATPRECProperty = get(FLOATPREC, varargin)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:54 $

%CGPRECFLOAT/GET  Get properties of a cgprecfloat object.
%
%   FLOATPRECProperty = GET(FLOATPREC, Property) returns the specified
%   property Property of the cgprecfloat object FLOATPREC.
%
%   FLOATPRECProperty = GET(FLOATPREC) returns all available properties
%   of the cgprecfloat object.
%
%   See also  CGPRECFLOAT

% ---------------------------------------------------------------------------
% Description : Method to get properties of a cgprecfloat object
%               FLOATPREC.
% Inputs      : FLOATPREC         - cgprecfloat object specifying the
%                                   mantissa bits, the exponent bits and the
%                                   admissible physical range
% Opt inputs  : Property          - cgprecfloat object property name
%                                   (char)
% Outputs     : FLOATPRECProperty - property value (cell/dbl)
% ---------------------------------------------------------------------------

switch nargin,
case 1,
    % Return all available properties in a cell array
    FLOATPRECProperty           = get(FLOATPREC.cgprec);
    FLOATPRECProperty.mbits     = FLOATPREC.mbits;
    FLOATPRECProperty.ebits     = FLOATPREC.ebits;
    FLOATPRECProperty.bits      = FLOATPREC.mbits+FLOATPREC.ebits+1;
    FLOATPRECProperty.PhysRange = FLOATPREC.PhysRange;
otherwise,
    % Try to use extra input as a property name if valid
    Property = i_check(varargin{1}, 'Property');
    switch Property
    case 'mbits',
        % Return mbits
        FLOATPRECProperty = FLOATPREC.mbits;
    case 'ebits',
        % Return ebits
        FLOATPRECProperty = FLOATPREC.ebits;
    case 'bits'
        FLOATPRECProperty = FLOATPREC.mbits+FLOATPREC.ebits+1;
    case 'physrange',
        % Return PhysRange
        FLOATPRECProperty = FLOATPREC.PhysRange;
    otherwise
        if ~isempty(get(FLOATPREC.cgprec, varargin{1}))
            % Property was defined in the parent, get data from there
            FLOATPRECProperty = get(FLOATPREC.cgprec, varargin{1});
        else
            % Invalid property name, return empty
            FLOATPRECProperty = [];
        end % if
    end % if
end % switch

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'Property',
    out = '';
    if ischar(in)
        in = lower(in);
        switch in,
        case {'mbits','ebits','bits','physrange'}
            % Property name is mbits
            out = in;
        end % switch
    end % if
end % switch