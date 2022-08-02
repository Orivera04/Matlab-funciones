function ValueAtRisk = portvrisk(PortReturn, PortRisk, RiskThreshold, PortValue)
%PORTVRISK Portfolio Value-At-Risk
%  ValueAtRisk = portvrisk(PortReturn, PortRisk, RiskThreshold, PortValue)
%  returns the potential loss in the value of a portfolio over one 
%  period of time, given the loss probability level RiskThreshold.
%
%  Inputs:
%    PortReturn is an NPORTSx1 vector or scalar of the expected return 
%    of each portfolio over the period.
%
%    PortRisk is an NPORTSx1 vector or scalar of the standard deviation  
%    of each portfolio over the period. 
%            
%    RiskThreshold is an NPORTSx1 vector or scalar specifying the loss 
%    probability. The default value is 0.05 (5%).
%
%    PortValue is an NPORTSx1 vector or scalar specifying the total value 
%    of asset portfolio. The default value is 1.
% 
%  Outputs:
%    ValueAtRisk is an NPORTSx1 vector of the estimated maximum loss in the  
%    portfolio, predicted with a confidence probability of 1 - RiskThreshold.
%
%    With probability 1-RiskThreshold the loss will be ValueAtRisk
%    or less, while with probability RiskThreshold the loss will be
%    ValueAtRisk or more.
%
%  Notes: 
%    If PortValue is not given, ValueAtRisk is presented on a per-unit
%    basis. A value of zero indicates no losses.
%    
%    If PortReturn and PortRisk are in dollar units, then PortValue should 
%    be 1. If PortReturn and PortRisk are on a percentage basis, then
%    PortValue should be the total value of the portfolio.
%
%
%  See also PORTOPT, FRONTCON
%

%  Author(s): M. Reyes-Kattar, 05/11/98
%  Copyright 1995-2002 The MathWorks, Inc.  
%  $Revision: 1.7 $   $ Date: 1998/05/11 13:45:34 $

% Check for input errors

if (nargin < 4)
    PortValue = 1;
end
  
if (nargin < 3 )
   RiskThreshold = 0.05;
end

if (nargin < 2)
   error('You must enter PortReturn and PortRisk');
end

% Make sure all arguments are columns
PortReturn = PortReturn(:);
PortRisk = PortRisk(:);
RiskThreshold = RiskThreshold(:);
PortValue = PortValue(:);

if(any(size(PortReturn) ~= size(PortRisk)))
   error('PortReturn and PortRisk must be of the same length');
end

ArgSize = [];

ArgSize = checkSize(ArgSize, PortReturn);
ArgSize = checkSize(ArgSize, PortRisk);
ArgSize = checkSize(ArgSize, PortValue);
ArgSize = checkSize(ArgSize, RiskThreshold );

%x = norminv(p,mu,sigma)
X = norminv(RiskThreshold, PortReturn, PortRisk); 
ValueAtRisk  = (-min(X,0) .* PortValue);


function NewSize = checkSize(OldSize, Arg)
% This function checks consistency between OldSize and the
% size of Arg. If Arg is an array and OldSize is empty, NewSize 
% returns the size of Arg.

% Author(s): J. Akao, 05/14/98

NewSize = [];
Size = size(Arg);
if ( any( Size ~= [1 1] ) )
  % argument is not a scalar
  if isempty(OldSize)
    % all previous arguments are scalar
    NewSize = Size;
  else
    % check size against previous arguments
    if ( any( Size ~= OldSize ) )
      error('Arguments must be scalars or consistent vectors');
    end
  end  
end
