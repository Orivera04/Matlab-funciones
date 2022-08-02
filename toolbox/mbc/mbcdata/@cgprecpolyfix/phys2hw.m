function HWValues = phys2hw(POLYFIXPREC, PhysValues)
%PHYS2HW

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:13 $

%CGPRECPOLYFIX/PHYS2HW  Convert physical values to hardware values.
%
%   HWValues = phys2hw(POLYFIXPREC, PhysValues) converts physical values
%   HWValues to hardware values PhysValues using a polynomial-based mapping
%   from physical values to hardware values specified by the cgprecpolyfix
%   object POLYFIXPREC.
%
%   See also  CGPRECPOLYFIX, HW2PHYS, RESOLVE

% ---------------------------------------------------------------------------
% Description : Method to convert physical values to hardware values for the
%               cgprecpolyfix class.
% Inputs      : PhysValues  - physical values (dbl)
%               POLYFIXPREC - cgprecpolyfix object specifying the
%                             polynomial-based mapping from physical values
%                             to hardware values and the admissible physical
%                             range
% Outputs     : HWValues    - hardware values (dbl)
% ---------------------------------------------------------------------------

% Error check on PhysValues
PhysValues = i_check(PhysValues, 'PhysValues');
% No error check required for POLYFIXPREC, since this method is only
% executed if POLYFIXPREC is a cgprecpolyfix object

% Resolve to admissible physical values
PhysValues = physresolve(POLYFIXPREC, PhysValues);

% Fetch polynomial coefficients for the physical to hardware conversion
NumCoeff  = get(POLYFIXPREC, 'NumCoeff');
DenCoeff  = get(POLYFIXPREC, 'DenCoeff');
PhysRange = get(POLYFIXPREC, 'PhysRange');

% Convert physical values to continuous pseudo-hardware values
HWValues = polyval(NumCoeff,PhysValues)./polyval(DenCoeff,PhysValues);

% Round the pseudo-hardware values to the nearest admissible values
HWValues = hwresolve(POLYFIXPREC, HWValues);

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