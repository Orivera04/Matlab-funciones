function PhysValuesOut = increment(FLOATPREC, PhysValuesIn, varargin)
%INCREMENT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:56 $

%CGPRECFLOAT/INCREMENT  Increment physical values.
%
%   This functionality is unsupported for floating point numbers.  Instead,
%   unresolved physical values PhysValuesIn are simply converted to resolved
%   physical values PhysValuesOut using the achievable resolution specififed
%   by the cgprecfloat object FLOATPREC.

% ---------------------------------------------------------------------------

% Resolve physical values
PhysValuesOut = resolve(FLOATPREC, PhysValuesIn);