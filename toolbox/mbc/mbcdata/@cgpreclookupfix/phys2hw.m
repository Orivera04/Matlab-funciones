function HWValues = phys2hw(LOOKUPFIXPREC, PhysValues)
%PHYS2HW

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:05 $

%CGPRECLOOKUPFIX/PHYS2HW  Convert physical values to hardware values.
%
%   HWValues = phys2hw(LOOKUPFIXPREC, PhysValues) converts physical values
%   PhysValues to hardware values HWValues using a lookup table and hardware
%   precision described by the cgpreclookupfix object LOOKFIXUPPREC.
%
%   See also  CGPRECLOOKUPFIX, HW2PHYS, RESOLVE

% ---------------------------------------------------------------------------
% Description : Method to convert physical values to hardware values for the
%               cgpreclookupfix class.
% Inputs      : PhysValues    - physical values (dbl)
%               LOOKUPFIXPREC - cgpreclookupfix object specifying table
%                               data, interpolation method and the admissible
%                               physical range
% Outputs     : HWValues      - hardware values (dbl)
% ---------------------------------------------------------------------------

% Error check on PhysValues
PhysValues = i_check(PhysValues, 'PhysValues');
% No error check required for LOOKUPFIXPREC, since this method is only
% executed if LOOKUPFIXPREC is a cgpreclookupfix object

% Clip the physical values to range specified by PhysRange
PhysValues = physresolve(LOOKUPFIXPREC, PhysValues);

% Fetch lookup table data and interpolation method for the physical to
% hardware conversion
TablePhysData = get(LOOKUPFIXPREC, 'TablePhysData');
TableHWData   = get(LOOKUPFIXPREC, 'TableHWData');

% Find HWValues by linear interpolation, see 'help interp1' for more info
HWValues = interp1(TablePhysData, TableHWData, PhysValues);
% Note that nonlinear interpolation routines can give undesirable solutions

% Round the pseudo-hardware values to the nearest admissible values
HWValues = hwresolve(LOOKUPFIXPREC, HWValues);

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