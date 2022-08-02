function PhysValuesOut = increment(FIXPREC, PhysValuesIn, varargin)
%INCREMENT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:49 $

%CGPRECFIX/INCREMENT  Increment physical values.
%
%   PhysValuesOut = INCREMENT(FIXPREC, PhysValuesIn) increments unresolved
%   physical values PhysValuesIn by one unit of hardware resolution and
%   returns resolved physical values PhysValuesOut.
%
%   PhysValuesOut = INCREMENT(FIXPREC, PhysValuesIn, HWMultiplier) increments
%   unresolved physical values by HWMultiplier units of hardware resolution.
%
%   See also  CGPRECLOOKUPFIX, CGPRECPOLYFIX, PHYS2HW, HW2PHYS

% ---------------------------------------------------------------------------
% Description : Method to convert increment unresolved physical values
%               PhysValuesIn by multiple units of hardware resolution and
%               return resolved physical values PhysValuesOut.
% Inputs      : PhysValuesIn  - unresolved physical values (dbl)
%               FIXPREC       - cgprecfix object specifying table data,
%                               and the admissible physical range.  Note that
%                               this method works with children of a
%                               cgprecfix object, e.g. cgpreclookupfix,
%                               cgprecpolyfix
% Outputs     : PhysValuesOut - resolved physical values (dbl)
% ---------------------------------------------------------------------------

% No error checking required for LOOKUPFIXPREC, since this method is only
% executed if LOOKUPFIXPREC is a cgprecfloat object.  No explicit
% error checking required on PhysValuesIn since both phys2hw and hw2phys
% have their own error checking.

if isempty(strmatch('phys2hw',methods(FIXPREC)))
    % If increment is called on a cgprecfix object (rather than a child of
    % cgprecfix such as cgprecpolyfix or cgpreclookupfix), then the
    % method phys2hw is not defined.  In this case, display a warning and
    % return unchanged physical values.
    warning(['method increment should be used with objects of '...
            'type cgpreclookupfix, cgprecpolyfix']);
    PhysValuesOut = PhysValuesIn;
    return
end

% Convert physical values to hardware values
HWValues = phys2hw(FIXPREC, PhysValuesIn);

% Increment hardware values by Incr hardware units
HWValues = hwincrement(FIXPREC, HWValues, varargin{1});

% Convert hardware values to (resolved) physical values
PhysValuesOut = hw2phys(FIXPREC, HWValues);