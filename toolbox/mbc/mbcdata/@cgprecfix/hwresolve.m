function HWValuesOut = hwresolve(FIXPREC, HWValuesIn)
%HWRESOLVE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:48 $

%CGPRECFIX/HWRESOLVE   Resolve to achievable fixed point hardware
%   values.
%
%   HWValuesOut = HWRESOLVE(FIXPREC, HWValuesIn) converts unresolved hardware
%   values HWValuesIn to resolved hardware values HWValuesOut using the
%   achievable resolution specified by the cgprecfix object FIXPREC.
%
%   See also  CGPRECFIX

% ---------------------------------------------------------------------------
% Description : Method to resolve to achievable fixed point hardware values.
% Inputs      : HWValuesIn   - unresolved hardware values (dbl)
%               FIXPREC      - cgprecfix object specifying the bits,
%                              un/signed, the fixed point position and the
%                              admissible physical range
% Outputs     : HWValuesOut  - resolved hardware values (dbl)
% ---------------------------------------------------------------------------

% Error check on HWValues
HWValuesIn = i_check(HWValuesIn, 'HWValues');
% No error check required for FLOATPREC, since this method is only executed
% if FLOATPREC is a cgprecfloat object

% Get hardware range and resolution from the cgprecfix object FIXPREC
HWRange      = get(FIXPREC, 'HWRange');
HWResolution = get(FIXPREC, 'HWResolution');

% Resolve to the nearest value modulo HWResolution
HWValuesOut = round(HWValuesIn/HWResolution)*HWResolution;

% The minimum achievable value is HWRange(1)
HWValuesOut(HWValuesOut<HWRange(1)) = HWRange(1);
% The maximum achievable value is HWRange(2)
HWValuesOut(HWValuesOut>HWRange(2)) = HWRange(2);

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
end % switch