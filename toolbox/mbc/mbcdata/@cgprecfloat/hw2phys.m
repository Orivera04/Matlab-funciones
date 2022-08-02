function PhysValues = hw2phys(FLOATPREC, HWValues)
%HW2PHYS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:55 $

%CGPRECFLOAT/HW2PHYS   Convert floating point hardware representation to
%   physical representation.
%
%   PhysValues = HW2PHYS(FLOATPREC, HWValues) converts floating point
%   hardware values HWValues to physical values PhysValues using the
%   achievable resolution specified by the cgprecfloat object FLOATPREC.
%
%   See also  PHYS2HW, RESOLVE, CGPRECFLOAT

% ---------------------------------------------------------------------------
% Description : Method to convert floating point hardware representation to 
%               physical representation.
% Inputs      : HWValues   - hardware values (dbl struct)
%             : FLOATPREC  - floatprecison object specifying the mantissa
%                            bits, the exponent bits and the admissible
%                            physical range
% Outputs     : PhysValues - physical values (dlb)
% ---------------------------------------------------------------------------

% Error check on HWValues structure
HWValues = i_check(HWValues, 'HWValues');
% Error check on HWValues.mantissa
HWValues.mantissa = i_check(HWValues.mantissa, 'HWValues.mantissa');
% Error check on HWValues.exponent
HWValues.exponent = i_check(HWValues.exponent, 'HWValues.exponent');
% Error check on HWValues.sign
HWValues.sign = i_check(HWValues.sign, 'HWValues.sign');
% No error check required for FLOATPREC, since this method is only executed
% if FLOATPREC is a cgprecfloat object

% Initialise PhysValues array
PhysValues = zeros(size(HWValues.mantissa));

% Calculate nonzero physical values
% Use the equation n = (1+f)*2^e where n is the physical value, f is the
% mantissa (0<f<1) and e is the exponent.  Reference: "Floating Points - IEEE
% Standard Unifies Arithmetic Model", available online at
% http://www.mathworks.co.uk/company/newsletter/pdf/Fall96Cleve.pdf
PhysValues(~isinf(HWValues.exponent)) = ...
    ((1+HWValues.mantissa(~isinf(HWValues.exponent))).* ...  % mantissa term
    (2.^HWValues.exponent(~isinf(HWValues.exponent)))).* ... % exponent term
    HWValues.sign(~isinf(HWValues.exponent));                % sign

% Insert zero physical values as required
PhysValues(isinf(HWValues.exponent)) = 0;

% Resolve to admissible physical values
% PhysRange = physresolve(PhysValues, FLOATPREC);

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case {'HWValues'},
    if ~isstruct(in)
        % HWValues is not a structure
        error([mfilename ': ' VarName ' must be a structure']);
    elseif ~isfield(in, 'mantissa')
        % HWValues does not have a field mantissa
        error([mfilename ': structure ' VarName ...
                ' must have field mantissa']);
    elseif ~isfield(in, 'exponent')
        % HWValues does not have a field exponent
        error([mfilename ': structure ' VarName ...
                ' must have field exponent']);
    elseif ~isfield(in, 'sign')
        % HWValues does not have a field sign
        error([mfilename ': structure ' VarName ...
                ' must have field sign']);
    else
        out = in;
    end % if
case {'HWValues.mantissa','HWValues.exponent'},
    if ~isnumeric(in)
        % HWValues.mantissa, HWValues.exponent is nonnumeric
        error([mfilename ': nonnumeric ' VarName]);
    elseif ~isreal(in)
        % HWValues.mantissa, HWValues.exponent is not real
        error([mfilename ': ' VarName ' must be real']);
    else
        % HWValues.mantissa, HWValues.exponent is valid
        out = in;
    end % if
case {'HWValues.sign'},
    if ~isnumeric(in)
        % HWValues.sign is nonnumeric
        error([mfilename ': nonnumeric ' VarName]);
    elseif ~isreal(in)
        % HWValues.sign is not real
        error([mfilename ': ' VarName ' must be real']);
    else
        % HWValues.sign is valid
        out = sign(in);
    end % if
end % switch