function TFactors = tmfactor(Settle, Maturity)
%TMFACTOR Time Factors of arbitrary dates
%
%   TFactors = tmfactor(Settle, Maturity)
%
%   Summary: This function determines the time factors from a vector of 
%           of Settlement dates to a vector of Maturity dates.
%
%   Inputs: Settle (Required)
%           Maturity (Required)
%
%           All required arguments must be Nx1 or 1xN conforming
%           vectors or scalar arguments. All optional arguments must be either
%           Nx1 or 1xN conforming vectors, scalars, or empty matrices.
%
%           For a detailed description of each input and output argument, at
%           the command line type: 'help ftb' + the argument name (e.g. for
%           help on Settle, type: "help ftbSettle").
%
%   Outputs: TFactors
%
%   See also CFAMOUNTS, CFTIMES.
 
%Author(s): Charlie Bassignani, 10-17-97, 02-13-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.8 $   $Date: 2002/04/14 21:49:38 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parse Settle and Maturity for strings
Settle = datenum(Settle);
Maturity = datenum(Maturity);

% Expand Settle and Maturity to column vectors
Settle = Settle(:);
Maturity = Maturity(:);

NumBonds = max( length(Settle), length(Maturity) );

if ( length(Settle)==1 )
  Settle = Settle(ones(NumBonds,1));
elseif ( length(Settle) ~= NumBonds )
  error('Settle and Maturity must be scalar or conforming vectors')
end
  
if ( length(Maturity)==1 )
  Maturity = Maturity(ones(NumBonds,1));
elseif ( length(Maturity) ~= NumBonds )
  error('Settle and Maturity must be scalar or conforming vectors')
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%               ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get the time factors for the bond(s) by calling CFAMOUNTS and getting
%the appropriate output argument

% Send dates over as zero coupon bonds, actual/actual, EOM off
Period = 0;
Basis = 0;
EOM = 0;

% Check if Maturity preceeds settle
ReverseMask = Settle > Maturity;

% Build the starting dates
StartDates = Settle;
StartDates(ReverseMask) = Maturity(ReverseMask);

EndDates = Maturity;
EndDates(ReverseMask) = Settle(ReverseMask);

[Temp, Temp1, TFactors] = cfamounts([], StartDates, EndDates, ...
    Period, Basis, EOM);

% return time factors without settlement
TFactors = TFactors(:,2:end);

TFactors(ReverseMask) = -TFactors(ReverseMask);