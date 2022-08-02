function PhysValues = hw2phys(LOOKUPFIXPREC, HWValues)
%HW2PHYS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:04 $

%CGPRECLOOKUPFIX/HW2PHYS  Convert hardware values to physical values.
%
%   PhysValues = hw2phys(LOOKUPFIXPREC, HWValues) converts hardware values
%   HWValues to physical values PhysValues using a lookup table and hardware
%   precision described by the cgpreclookupfix object LOOKUPFIXPREC.
%
%   See also  CGPRECLOOKUPFIX, PHYS2HW, RESOLVE

% ---------------------------------------------------------------------------
% Description : Method to convert hardware values to physical values for the
%               cgpreclookupfix class.
% Inputs      : HWValues      - hardware values (dbl)
%               LOOKUPFIXPREC - cgpreclookupfix object specifying hardware
%                               range and physical to hardware mapping
%                               function
% Outputs     : PhysValues    - physical values (dbl)
% ---------------------------------------------------------------------------

% Error check on HWValues
HWValues = i_check(HWValues, 'HWValues');
% No error check required for LOOKUPFIXPREC, since this method is only
% executed if LOOKUPFIXPREC is a cgpreclookupfix object

% Resolve to achievable fixed point hardware values
HWValues = hwresolve(LOOKUPFIXPREC, HWValues);

% Fetch lookup table data and interpolation method for the physical to
% hardware conversion
TablePhysData = get(LOOKUPFIXPREC, 'TablePhysData');
TableHWData   = get(LOOKUPFIXPREC, 'TableHWData');

% Find PhysValues by linear interpolation, see 'help interp1' for more info
PhysValues = interp1(TableHWData, TablePhysData, HWValues);
% Note that nonlinear interpolation routines can give undesirable solutions

% Resolve to admissible physical values
PhysValues = physresolve(LOOKUPFIXPREC, PhysValues);

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