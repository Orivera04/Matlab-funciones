function FIXPREC = set(FIXPREC, PropertyName, PropertyValue)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:51 $

%CGPRECFIX/SET  Set properties of a cgprecfix object.
%
%   FIXPREC = SET(FIXPREC, PropertyName, PropertyValue) modifies
%   the property PropertyName of a cgprecfix object FIXPREC to a value
%   PropertyValue.
%
%   See also  CGPRECFIX

% ---------------------------------------------------------------------------
% Description : Method to set properties of a cgprecfix object.
% Inputs      : FIXPREC       - cgprecfix object
%               PropertyName  - property to be modified (str)
%               PropertyValue - modified property value
% Outputs     : FIXPREC       - (modified) cgprecfix object
% ---------------------------------------------------------------------------

switch nargin,
case 3,
    % Try to use extra input as a property name if valid
    PropertyName = i_check(PropertyName, 'PropertyName');
    switch PropertyName
    case 'bits',
        % Set bits
        FIXPREC.bits = PropertyValue;
    case 'signed',
        % Set signed
        FIXPREC.signed = PropertyValue;
        % Update dependent object properties
        FIXPREC = i_update(FIXPREC);
    case 'ptpos',
        % Set ptpos
        FIXPREC.ptpos = PropertyValue;
        % Update dependent object properties
        FIXPREC = i_update(FIXPREC);
    otherwise
        % No valid property name at this level, try the superclass
        FIXPREC.cgprec = ...
            set(FIXPREC.cgprec, PropertyName, PropertyValue);
    end % switch
otherwise
    % Incorrect number of input arguments
    error('Incorrect number of input arguments.');
end % switch

% ---------------------------------------------------------------------------

function FIXPREC = i_update(FIXPREC)

% Update dependent object properties: HWRange and HWResolution

% Update HWResolution
FIXPREC.HWResolution = 1/(2^FIXPREC.ptpos);
% Update HWRange
if FIXPREC.signed==0
    % unsigned
    FIXPREC.HWRange = [0 2^FIXPREC.bits-1]/(2^FIXPREC.ptpos);
else
    % signed
    FIXPREC.HWRange = [1-2^(FIXPREC.bits-1) 2^(FIXPREC.bits-1)]/(2^FIXPREC.ptpos);
end

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
        case 'bits',
            % Property name is bits
            out = 'bits';
        case 'signed',
            % Property name is signed
            out = 'signed';
        case 'ptpos',
            % Property name is ptpos
            out = 'ptpos';
        otherwise
            % PropertyName is not defined at this level
            out = in;
        end % switch
    end % if
end % switch