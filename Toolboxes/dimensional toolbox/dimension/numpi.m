function [npi,nbase] = numpi(RL);
% NUMPI calculate number of pis and base variables
%  [nPI,nBASE] = NUMPI(RL) calculates the number of
%  dimensionless groups nPI and the number of base
%  variables nBASE which are needed for the problem.
%  The number of dimensionless groups equals the
%  number of dependent variables.

% Dimensional Analysis Toolbox for Matlab
% Steffen Brückner, 2002-02-10

% check input arguments
msg = nargchk(1,1,nargin);
if msg
    error(msg);
    break;
end

% determine the dimensional matrix
D = [RL.Dimension];

% determin the rank of the dimensional matrix, which
% equals the number of base variables
nbase = rank(D);

% Well, the number of dimensionless groups is now
% given by the size of the dimensional matrix minus
% the number of base variables
npi = size(D,2) - nbase;
