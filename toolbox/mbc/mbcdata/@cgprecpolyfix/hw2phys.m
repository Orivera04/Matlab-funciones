function PhysValues = hw2phys(POLYFIXPREC, HWValues)
%HW2PHYS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:12 $

%CGPRECPOLYFIX/HW2PHYS  Convert hardware values to physical values.
%
%   PhysValues = hw2phys(POLYFIXPREC, HWValues) converts hardware values
%   HWValues to physical values PhysValues using a polynomial-based mapping
%   from physical values to hardware values specified by the cgprecpolyfix
%   object POLYFIXPREC.
%
%   See also  CGPRECPOLYFIX, PHYS2HW, RESOLVE

% ---------------------------------------------------------------------------
% Description : Method to convert hardware values to physical values for the
%               cgprecpolyfix class.
% Inputs      : HWValues    - hardware values (dbl)
%               POLYFIXPREC - cgprecpolyfix object specifying the
%                             polynomial-based mapping from physical values
%                             to hardware values and the admissible physical
%                             range
% Outputs     : PhysValues  - physical values (dbl)
% ---------------------------------------------------------------------------

% Error check on HWValues
HWValues = i_check(HWValues, 'HWValues');
% No error check required for POLYFIXPREC, since this method is only
% executed if POLYFIXPREC is a cgprecpolyfix object

% Fetch polynomial coefficients for the physical to hardware conversion
NumCoeff  = get(POLYFIXPREC, 'NumCoeff');
DenCoeff  = get(POLYFIXPREC, 'DenCoeff');
PhysRange = get(POLYFIXPREC, 'PhysRange');

% Resolve to achievable fixed point hardware values
HWValues = hwresolve(POLYFIXPREC, HWValues);

% Initialise PhysValues
PhysValues = zeros(size(HWValues));
% It isn't possible to vectorise calculations using 'roots'
for rcount = 1:size(HWValues,1), % rows
    for ccount = 1:size(HWValues,2), % columns
        % Solve (soln is the solution)
        soln = roots(NumCoeff-HWValues(rcount,ccount)*DenCoeff);
        % Discard complex solutions
        soln = soln(abs(imag(soln))<1e-6);
        soln = real(soln);
        if all(soln<PhysRange(1))
            % All real solutions are less than the minimum admissible value,
            % set the values to this maximum value
            soln = PhysRange(1);
        elseif all(soln>PhysRange(2))
            % All real solutions are greater than the maximum admissible
            % value, set the values to this maximum value
            soln = PhysRange(2);
        elseif isempty(soln)
            % No real solutions, flag with NaN
            soln = NaN;
        else
            % Multiple valid real solutions: To avoid problems with nonunique
            % roots of the polynomial, keep only the largest valid real
            % solution
            soln = max(soln);
        end % if
        % Add this solution to PhysValues
        PhysValues(rcount,ccount) = soln;
    end % for (columns)
end % for (rows)

% Resolve to admissible physical values
PhysValues = physresolve(POLYFIXPREC, PhysValues);

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