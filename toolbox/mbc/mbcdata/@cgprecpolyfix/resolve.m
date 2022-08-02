function PhysValuesOut = resolve(POLYFIXPREC, PhysValuesIn)
%RESOLVE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:15 $

%CGPRECPOLYFIX/RESOLVE  Convert physical values to hardware values.
%
%   PhysValuesOut = RESOLVE(POLYFIXPREC, PhysValuesIn) converts unresolved
%   physical values PhysValuesIn to resolved physical values PhysValuesOut
%   using a poly table and hardware precision described by the
%   cgprecpolyfix object POLYFIXPREC.
%
%   See also  CGPRECPOLYFIX, PHYS2HW, HW2PHYS

% ---------------------------------------------------------------------------
% Description : Method to convert unresolved physical values PhysValuesIn to
%               resolved physical values PhysValuesOut for the
%               cgprecpolyfix class.
% Inputs      : PhysValuesIn  - unresolved physical values (dbl)
%               POLYFIXPREC   - cgprecpolyfix object specifying the
%                               polynomial-based mapping from physical values
%                               to hardware values and the admissible
%                               physical range
% Outputs     : PhysValuesOut - resolved physical values (dbl)
% ---------------------------------------------------------------------------

% No error checking required for POLYFIXPREC, since this method is only
% executed if POLYFIXPREC is a cgprecfloat object.  No explicit
% error checking required on PhysValuesIn since both phys2hw and hw2phys
% have their own error checking.

% Convert physical values to hardware values
HWValues = phys2hw(POLYFIXPREC, PhysValuesIn);

% Convert hardware values to (resolved) physical values
PhysValuesOut = hw2phys(POLYFIXPREC, HWValues);