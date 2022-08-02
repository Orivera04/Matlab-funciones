function HWValuesOut = hwincrement(FIXPREC, HWValuesIn, varargin)
%HWINCREMENT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:47 $

%CGPRECFIX/HWINCREMENT   Increment fixed point hardware values.
%
%   HWValuesOut = HWINCREMENT(FIXPREC, HWValuesIn) increments hardware values
%   HWValuesIn by 1 unit of hardware resolution.  The achievable resolution
%   is specified by the cgprecfix object FIXPREC.
%
%   HWValuesOut = HWINCREMENT(FIXPREC, HWValuesIn, HWMultiplier) imcrements
%   hardware values by HWMultiplier units of hardware resolution.
%
%   See also  HWRESOLVE, CGPRECFIX

% ---------------------------------------------------------------------------
% Description : Method to increment fixed point hardware values.
% Inputs      : HWValuesIn   - original hardware values (dbl)
%               FIXPREC      - cgprecfix object specifying the bits,
%                              un/signed, the fixed point position and the
%                              admissible physical range
% Opt inputs  : HWMultiplier - number of hardware resolution steps by which
%                              HWValues are to be incremented (int)
% Outputs     : HWValuesOut  - incremented hardware values (dbl)
% ---------------------------------------------------------------------------

% Error check on HWValues
HWValuesIn = i_check(HWValuesIn, 'HWValues');
% No error check required for FLOATPREC, since this method is only executed
% if FLOATPREC is a cgprecfloat object
% Error check on varargin (HWIncrement)
if nargin<3
    % Information about increment not specified, use the default value of 1
    % unit of hardware resolution
    HWIncrement = get(FIXPREC, 'HWResolution');
else
    % Try to use extra input as a multiplier HWMultiplier such that the
    % increment is the product of HWMultiplier and the hardware resolution
    HWMultiplier = i_check(varargin{1}, 'HWMultiplier');
    HWIncrement = HWMultiplier*get(FIXPREC, 'HWResolution');
end % if

% Increment hardware values
HWValuesOut = HWValuesIn + HWIncrement;

% Resolve to achievable hardware values
HWValuesOut = hwresolve(FIXPREC, HWValuesOut);

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'HWValues',
    if ~isnumeric(in)
        % HWValues is nonnumeric
        error([mfilename ': nonnumeric ' VarName]);
    elseif ~isreal(in)
        % HWValues is not real
        error([mfilename ': ' VarName ' must be real']);
    else
        % HWValues is valid
        out = in;
    end % if
case 'HWMultiplier',
    if isnumeric(in)&isreal(in)&(length(in)==1)
        % HWMultiplier is a real scalar
        out = in;
    else
        % HWMultiplier is not a real scalar, use default value
        warning([VarName ' must be a real scalar, '...
                'using the default value of 1.']);
        out = 1;
    end % if
end % switch