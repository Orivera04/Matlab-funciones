function PhysValuesOut = resolve(FLOATPREC, PhysValuesIn)
%RESOLVE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:59 $

%CGPRECFLOAT/RESOLVE  Resolve to achievable physical values.
%
%   PhysValuesOut = RESOLVE(FLOATPREC, PhysValuesIn) converts unresolved
%   physical values PhysValuesIn to resolved physical values PhysValuesOut
%   using the achievable resolution specififed by the cgprecfloat object
%   FLOATPREC.
%
%   See also  PHYS2HW, HW2PHYS, CGPRECFLOAT

% ---------------------------------------------------------------------------
% Description : Method to resolve to achievable physical values.
% Inputs      : PhysValuesIn  - unresolved physical values (dbl)
%             : FLOATPREC     - cgprecfloat object specifying the
%                               mantissa bits, the exponent bits and the
%                               admissible physical range
% Outputs     : PhysValuesOut - resolved physical values (dbl)
% ---------------------------------------------------------------------------

% Set flag to define whether MATLAB's built-in DOUBLE and SINGLE functions
% are used
USE_BUILTIN_FNS = 1;

% No error checking required for FLOATPREC, since this method is only
% executed if FLOATPREC is a cgprecfloat object.  No explicit
% error checking required on PhysValuesIn since both phys2hw and hw2phys
% have their own error checking, except in the case where phys2hw and hw2phys
% are bypassed by using the builtin MATLAB functions single and double.
if (FLOATPREC.mbits == 52 & FLOATPREC.ebits == 11 & USE_BUILTIN_FNS == 1)|...
        (FLOATPREC.mbits == 23 & FLOATPREC.ebits == 8 & USE_BUILTIN_FNS == 1)
    % FLOATPREC is an IEEE single or double precision object
    % Error check on PhysValuesIn
    PhysValuesOut = i_check(PhysValuesIn, 'PhysValues');
    % Get physical range from the cgprecfix object FLOATPREC
    PhysRange = get(FLOATPREC, 'PhysRange');
    % The minimum achievable value is PhysRange(1)
    PhysValuesOut(PhysValuesIn<PhysRange(1)) = PhysRange(1);
    % The maximum achievable value is PhysRange(2)
    PhysValuesOut(PhysValuesIn>PhysRange(2)) = PhysRange(2);
    if FLOATPREC.mbits == 23
        % IEEE single precision
        PhysValuesOut = double(single(PhysValuesOut));
        % Otherwise it is IEEE double precision, no change to PhysValuesOut
    end
else
    % Convert physical values to hardware values
    HWValues = phys2hw(FLOATPREC, PhysValuesIn);
    % Convert hardware values back to physical values
    PhysValuesOut = hw2phys(FLOATPREC, HWValues);
end

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'PhysValues',
    if ~isnumeric(in)
        % PhysValues is nonnumeric
        error([mfilename ': nonnumeric ' VarName]);
    elseif ~isreal(in)
        % PhysValues is not real
        error([mfilename ': ' VarName ' must be real']);
    else
        % PhysValues is valid
        out = in;
    end % if
end % switch