function FIXPRECProperty = get(FIXPREC, varargin)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:46 $

%CGPRECFIX/GET  Get properties of a cgprecfix object.
%
%   FIXPRECProperty = GET(FIXPREC, Property) returns the specified property
%   Property of the cgprecfix object FIXPREC.
%
%   FIXPRECProperty = GET(FIXPREC) returns all available properties of the
%   cgprecfix object.
%
%   See also  CGPRECFIX

% ---------------------------------------------------------------------------
% Description : Method to get properties of a cgprecfix object FIXPREC.
% Inputs      : FIXPREC         - cgprecfix object specifying the bits,
%                                 un/signed, the fixed point position and
%                                 the admissible physical range
% Opt inputs  : Property        - cgprecfix object property name (char)
% Outputs     : FIXPRECProperty - property value (cell/dbl)
% ---------------------------------------------------------------------------

switch nargin,
case 1,
    % Return all available properties in a cell array
    FIXPRECProperty              = get(FIXPREC.cgprec);
    FIXPRECProperty.bits         = FIXPREC.bits;
    FIXPRECProperty.signed       = FIXPREC.signed;
    FIXPRECProperty.ptpos        = FIXPREC.ptpos;
    FIXPRECProperty.HWResolution = FIXPREC.HWResolution;
    FIXPRECProperty.HWRange      = FIXPREC.HWRange;
otherwise,
    % Try to use extra input as a property name if valid
    Property = i_check(varargin{1}, 'Property');
    switch Property
    case 'bits',
        % Return bits
        FIXPRECProperty = FIXPREC.bits;
    case 'signed',
        % Return signed
        FIXPRECProperty = FIXPREC.signed;
    case 'ptpos',
        % Return ptpos
        FIXPRECProperty = FIXPREC.ptpos;
    case 'HWResolution',
        % Return HWResolution
        FIXPRECProperty = FIXPREC.HWResolution;
    case 'HWRange',
        % Return HWRange
        FIXPRECProperty = FIXPREC.HWRange;
    otherwise
        if ~isempty(get(FIXPREC.cgprec, varargin{1}))
            % Property was defined in the parent, get data from there
            FIXPRECProperty = get(FIXPREC.cgprec, varargin{1});
        else
            % Invalid property name, return empty
            FIXPRECProperty = [];
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
        case 'bits',
            % Property name is bits
            out = 'bits';
        case 'signed',
            % Property name is signed
            out = 'signed';
        case 'ptpos',
            % Property name is ptpos
            out = 'ptpos';
        case 'hwresolution',
            % Property name is HWResolution
            out = 'HWResolution';
        case 'hwrange',
            % Property name is HWRange
            out = 'HWRange';
        otherwise
            % Invalid property name, use default value
            out = '';
        end % switch
    end % if
end % switch