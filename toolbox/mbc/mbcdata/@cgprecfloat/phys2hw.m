function HWValues = phys2hw(FLOATPREC, PhysValues)
%PHYS2HW

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:57 $

%CGPRECFLOAT/PHYS2HW  Convert physical representation to achievable
%   floating point hardware representation
%
%   HWValues = PHYS2HW(FLOATPREC, PhysValues) converts unresolved physical
%   values PhysValues to achievable floating point hardware values HWValues
%   using the achievable resolution specified by the cgprecfloat object
%   FLOATPREC.
%
%   See also  HW2PHYS, RESOLVE, CGPRECFLOAT

% ---------------------------------------------------------------------------
% Description : Method to convert physical representation to achievable
%               floating point hardware representation.
% Inputs      : PhysValues - physical values (dlb)
%             : FLOATPREC  - floatprecison object specifying the mantissa
%                            bits, the exponent bits and the admissible
%                            physical range
% Outputs     : HWValues   - hardware values (dbl struct)
% ---------------------------------------------------------------------------

% Error check on PhysValues
PhysValues = i_check(PhysValues, 'PhysValues');
% No error check required for FLOATPREC, since this method is only executed
% if FLOATPREC is a cgprecfloat object

% Clip the physical values to range specified by PhysRange
PhysRange = get(FLOATPREC, 'PhysRange');
PhysValues(PhysValues<PhysRange(1)) = PhysRange(1);
PhysValues(PhysValues>PhysRange(2)) = PhysRange(2);

% Get mantissa size and exponent size from cgprecfloat object
mbits = get(FLOATPREC, 'mbits');
ebits = get(FLOATPREC, 'ebits');

% Work with the magnitude of the raw values rather than the raw values
% themselves.  This simplifies the operations considerably since the
% calculation of the exponent involves logarithms.
AbsPhysValues = abs(PhysValues);

% Calculate the maximum and minimum exponent.  The minimum exponent is set to
% -2^(ebits-1) rather than 1-2^(ebits-1) to simplify the treatment of
% underflow.
minexponent = -2^(ebits-1);
maxexponent = 2^(ebits-1);
% Initialise HWValues.exponent array
HWValues.exponent = zeros(size(PhysValues));
% Calculate exponents of nonzero physical values
HWValues.exponent(AbsPhysValues~=0) = ...
    floor(log2(AbsPhysValues(AbsPhysValues~=0)));
% Set exponents of zero physical values
HWValues.exponent(AbsPhysValues==0) = -Inf;
% Adjust exponents to fit minimum and maximum achievable values in hardware
HWValues.exponent((HWValues.exponent<minexponent)& ...
                  (~isinf(HWValues.exponent))) = minexponent;
HWValues.exponent(HWValues.exponent>maxexponent) = maxexponent;

% Define the maximum and minimum mantissa
minmantissa = 0;
maxmantissa = 1;
% Initialise HWValues.mantissa array
HWValues.mantissa = zeros(size(PhysValues));
% Calculate exponents of nonzero physical values
HWValues.mantissa(AbsPhysValues~=0) = ...
    round((2^mbits)*(AbsPhysValues(AbsPhysValues~=0)- ...
          (2.^HWValues.exponent(AbsPhysValues~=0)))./ ...
          (2.^HWValues.exponent(AbsPhysValues~=0)))/(2^mbits);
% Adjust exponents to fit minimum and maximum achievable values in hardware
HWValues.mantissa(HWValues.mantissa<minmantissa) = minmantissa;
HWValues.mantissa(HWValues.mantissa>maxmantissa) = maxmantissa;

% Overflow
HWValues.mantissa((HWValues.mantissa==maxmantissa)& ...
    (HWValues.exponent==maxexponent)) = 1-1/2^(mbits);

% Tidy up the exponent and mantissa for the case where mantissa = 1
% by incrementing the exponent and resetting the mantissa to 0
HWValues.exponent(HWValues.mantissa==1) = ...
    HWValues.exponent(HWValues.mantissa==1)+1;
HWValues.mantissa(HWValues.mantissa==1) = 0;

% Underflow - identify the values to round down
HWValues.exponent(AbsPhysValues<(2^minexponent)) = -Inf;
HWValues.mantissa(AbsPhysValues<(2^minexponent)) = 0;
% Underflow - identify the values to round up
HWValues.exponent((AbsPhysValues>=(2^minexponent))& ...
    (AbsPhysValues<(2^(1+minexponent)))) = minexponent+1;
HWValues.mantissa((AbsPhysValues>=(2^minexponent))& ...
    (AbsPhysValues<(2^(1+minexponent)))) = 0;

% Set sign bit
HWValues.sign = sign(PhysValues);

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