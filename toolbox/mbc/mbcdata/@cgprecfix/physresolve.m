function PhysValuesOut = physresolve(FIXPREC, PhysValuesIn)
%PHYSRESOLVE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:50 $

%CGPRECFIX/PHYSRESOLVE   Resolve to achievable physical values.
%
%   PhysValuesOut = PHYSRESOLVE(FIXPREC, PhysValuesIn) converts potentially
%   inadmissible physical values PhysValuesIn to admissible physical values
%   PhysValuesOut using the achievable physical range specified by the
%   cgprecfix object FIXPREC.
%
%   See also  HWRESOLVE, RESOLVE, CGPRECFIX

% ---------------------------------------------------------------------------
% Description : Method to resolve to admissible physical values.
% Inputs      : PhysValuesIn  - potenitally inadmissible physical values
%                               (dbl)
%               FIXPREC       - cgprecfix object specifying the bits,
%                               un/signed, the fixed point position and the
%                               admissible physical range
% Outputs     : PhysValuesOut - admissible physical values (dbl)
% ---------------------------------------------------------------------------

% Error check on PhysValues
PhysValuesIn = i_check(PhysValuesIn, 'PhysValues');
% No error check required for FLOATPREC, since this method is only executed
% if FIXPREC is a cgprecfix object

% Set Output = Input
PhysValuesOut = PhysValuesIn;

% Get physical range from the cgprecfix object FIXPREC
PhysRange = get(FIXPREC, 'PhysRange');

if ~isempty(PhysRange)
    % The minimum achievable value is PhysRange(1)
    PhysValuesOut(PhysValuesIn<PhysRange(1)) = PhysRange(1);
    % The maximum achievable value is PhysRange(2)
    PhysValuesOut(PhysValuesIn>PhysRange(2)) = PhysRange(2);
else
    % If we call physresolve on a cgprecfix object (rather than a child of
    % cgprecfix such as cgprecpolyfix or cgpreclookupfix), then
    % PhysRange is not defined.  In this case, display a warning and set
    % PhysValuesOut = PhysValuesIn.
    warning(['method physresolve should be used with objects of '...
            'type cgpreclookupfix, cgprecpolyfix']);
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