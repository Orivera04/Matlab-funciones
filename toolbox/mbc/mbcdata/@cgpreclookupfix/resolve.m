function PhysValuesOut = resolve(LOOKUPFIXPREC, PhysValuesIn)
%RESOLVE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:07 $

%CGPRECLOOKUPFIX/RESOLVE  Convert physical values to hardware values.
%
%   PhysValuesOut = RESOLVE(LOOKUPFIXPREC, PhysValuesIn) converts unresolved
%   physical values PhysValuesIn to resolved physical values PhysValuesOut
%   using a lookup table and hardware precision described by the
%   cgpreclookupfix object LOOKUPFIXPREC.
%
%   See also  CGPRECLOOKUPFIX, PHYS2HW, HW2PHYS

% ---------------------------------------------------------------------------
% Description : Method to convert unresolved physical values PhysValuesIn to
%               resolved physical values PhysValuesOut for the
%               cgpreclookupfix class.
% Inputs      : PhysValuesIn  - unresolved physical values (dbl)
%               LOOKUPFIXPREC - cgpreclookupfix object specifying table
%                               data, interpolation method and the admissible
%                               physical range
% Outputs     : PhysValuesOut - resolved physical values (dbl)
% ---------------------------------------------------------------------------

% No error checking required for LOOKUPFIXPREC, since this method is only
% executed if LOOKUPFIXPREC is a cgprecfloat object.  No explicit
% error checking required on PhysValuesIn since both phys2hw and hw2phys
% have their own error checking.

% Convert physical values to hardware values
HWValues = phys2hw(LOOKUPFIXPREC, PhysValuesIn);

% Convert hardware values to (resolved) physical values
PhysValuesOut = hw2phys(LOOKUPFIXPREC, HWValues);