function [EndRates, EndTimes, EndDates] = zerobootcf(Prices, varargin)
%ZEROBOOTCF Zero curve bootstrapping engine.
%
%   [ZeroRates, EndTimes, EndDates] = zeroboot(Prices, ...
%      CFlowAmounts, CFlowDates, TFactors)
%
%   Inputs: Type "help cfamounts" for a description of cash flow arguments.
%     Price        - NINSTx1 market prices at time 0.
%     CFlowAmounts - NINSTxMOSTCFS matrix of cash flow amounts.
%     CFlowDates   - NINSTxMOSTCFS matrix of cash flow dates.
%     TFactors     - NINSTxMOSTCFS matrix of cash flow semi-annual time factors.
%
%   Outputs:
%     ZeroRates - NPOINTSx1 vector of zero rates which value the cash flow
%       streams at input Prices.  
%     EndTimes - NPOINTSx1 vector of semi-annual time factors to the Rate
%       maturities. 
%     EndDates - NPOINTSx1 vector of dates of the rate maturities.
%       EndDates are the unique maturities of the NINST cash flow streams.
%
%   Example:
%     [cfa,cfd,tf] = cfamounts(0.05,today,today+[300 (500:-200:100)])
%     zerobootcf(99:102, cfa, cfd, tf)
%
%   See also CFBYZERO, ZBTPRICE.

%   Author(s) : J. Akao 23-Mar-1999, K. Lui 5-Nov-2003
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.5.2.2 $   $Date: 2004/04/06 01:07:03 $ 

%---------------------------------------------------------------------
% Argument parsing
% Prices    [NumInst x 1]
% CFAmounts [NumInst x MostCFs]
% CFDates   [NumInst x MostCFs]
% CFTimes   [NumInst x MostCFs]
%---------------------------------------------------------------------

if nargin<2
  error('Finance:zerobootcf:missingRequiredArguments', ...
           'Prices and CFlowAmounts are required');
end

% Standard cash flow rules on the first 3 varargin
[CFAmounts, CFDates, CFTimes] = instargcf(varargin{1:min(3,end)});

% Prices should be (a column) of doubles
Prices = finargdble(Prices);
Prices = finargflip([Inf, 1], Prices);

% Size matching for prices
[Prices, CFAmounts, CFDates, CFTimes] = finargsz(1, ...
 Prices, CFAmounts, CFDates, CFTimes);

NumInst = length(Prices);

if nargin>=5
  % pick up explicit settle
  Settle = finargdate(varargin{4});
else
  % guess from CFDates
  Settle = CFDates( CFTimes==0 );
  if isempty(Settle)
    Settle = min(min(CFDates))-1;
  end
end
% Trim to a scalar
if any(Settle ~= Settle(1))
  error('Finance:zerobootcf:invalidSettleDate', ...
            'All instruments must settle on the same date')
else
  Settle = Settle(1);
end

%---------------------------------------------------------------------
% Add the prices at time 0 to create cash flow streams with present value
% equal to 0.
%---------------------------------------------------------------------

CFAmounts = [-Prices              CFAmounts];
CFDates =   [Settle*ones(NumInst,1) CFDates];
CFTimes =   [zeros(NumInst,1)       CFTimes];

%---------------------------------------------------------------------
% Expand the instruments to common dates and order according to maturity
% Create a cash flow stream for every point in the output zero curve.
%
% EndDates [NumPoints x 1]
% CFEnd    [NumPoints x 1]
% CFSet    [NumPoints x NumTimes]
% Dates                [NumTimes x 1]
% Times                [NumTimes x 1]
%---------------------------------------------------------------------

% Lay out the cash flows by instrument and by date
% CFSet [NumInst x NumTimes]
[CFSet, Dates, Times] = cfport(CFAmounts, CFDates, CFTimes);
NumTimes = length(Times);

% Find the maturity of each cash flow stream (max date of nonzero cash flow)
% Maturity [NumInst x 1]
[Maturity, I] = max(CFDates .* (CFAmounts~=0) ,[],2);

% Remember the maturity cash flow and time factor
CFEnd = CFAmounts( (1:NumInst)' + NumInst*(I-1) );
TFEnd = CFTimes(   (1:NumInst)' + NumInst*(I-1) );

% Find the ordered unique maturities for the output rates
% InstOrder [NumInst x 1] with entries 1 to NumPoints
[EndDates, I, InstOrder] = unique(Maturity);
NumPoints = length(EndDates);

% Make sure the problem is not overdetermined:
% Collapse cash flow streams which have the same maturity to reduce the
% NumInst cash flows to NumPoints synthetic cash flows.
%
% MatMap(j,i)==1 if instrument i belongs to point j
% MatMap [NumPoints x NumInst]
% CFSet  [NumPoints x NumTimes] from [NumInst x NumTimes] 
[JPoint, InstOrder] = ndgrid(1:NumPoints, InstOrder);
MatMap = (JPoint == InstOrder);

% Reduce the rows of CFSet by summing cash flows.
CFSet = MatMap*CFSet;
CFEnd = MatMap*CFEnd;

% Just pick up any examples of unique maturities
TFEnd = TFEnd(I);

%---------------------------------------------------------------------
% Map the relationship between the EndTimes (EndDates) and intermediate
% cash flows at Times (Dates).
% EndInd   [NumPoints x 1]
% EndDates [NumPoints x 1] = Dates(EndInd)
% EndTimes [NumPoints x 1] = Times(EndInd)
%
% RateMap  [NumTimes x NumPoints] : Rates = RateMap*EndRates
%---------------------------------------------------------------------
[EndDates, EndInd] = intersect(Dates, EndDates);
EndTimes = Times(EndInd);

% Cheat with interp to do the work for now
% It could be faster to do this by hand
RateMap = zeros(NumTimes, NumPoints);

% Extrapolate rates before the first maturity (EndDate)
RateMap(1:EndInd(1)-1,1) = 1;

% loop over the points to get their linear interpolation weights
% Only interpolate times after the first maturity at index EndInd(1)
for j=1:NumPoints,
  EndRates = zeros(NumPoints,1);
  EndRates(j) = 1;
  % Can use interp1 instead of interp1q for faster interpolation, but
  % no error checking will be involved, thus could lead to issues
  RateMap(EndInd(1):end,j) = interp1q(EndTimes, EndRates, Times(EndInd(1):end));  
  %  RateMap(EndInd(1):end,j)'
  
end

%---------------------------------------------------------------------
% Solve the NumPoints equations in NumPoints variables, EndRates.
% CFSet * [ (1 + 0.5*RateMap*EndRates).^(-Times) ] = 0s
% CFSet * Disc = 0s
%---------------------------------------------------------------------

% Initial guess for the rates ignoring intermediate cash flows
EndRates = 2*( (-CFEnd./CFSet(:,1)).^(1./TFEnd) - 1 );
EndRates = max(EndRates, 0.04);

fsolveOpt = optimset('Jacobian','on', 'Display','off', ...
                     'TolFun',1e-14,  'TolX',1e-12, ...
                     'MaxIter', 20);

% using optimization toolbox instead of Newton-Raphson method
% for better performance and accuracy, but will lose the ability to
% determine which rate it failed on.  Use method 1 or 2 below for iterative 
% approach
[EndRates, Residual, ExitFlag] = fsolve('zerobootsub',EndRates,fsolveOpt,...
                                        CFSet, Times, RateMap);

if ( ExitFlag < 0 )
    % convergence failure
    warning('Finance:zerobootcf:solutionConvergenceFailure', ...
              'Could not solve for the rate\n');
end
                                    
return

%  =======================================================================
%  Iterative approach Method 1:  custom Newton-Raphson iterative 
%  =======================================================================
%
%---------------------------------------------------------------------
% ZEROBOOTRS Iterative rate solver for zerobootcf function
%  Ri = zerobootrs(Ri, EndRates, CFSet, Times, RateMap, i)
%---------------------------------------------------------------------
% function Ri = zerobootrs(Ri, EndRates, CFSet, Times, RateMap, i)
% 
% % starting guess
% X = Ri;
% 
% % Stopping parameters
% TolFun = 1e-14; % price error
% TolX = 1e-12;   % rate error
% MaxIter = 20;   
% 
% DelX   = Inf;
% DelFun = Inf;
% Iter = 0;
% while ( DelX > TolX ) & ( DelFun > TolFun )
%   
%   % Compute pricing error and derivative
%   EndRates(i) = X;
% 
%   Rates = RateMap * EndRates;
%   Disc    = (1 + 0.5*Rates).^(-Times);
%   DelDisc = (1 + 0.5*Rates).^(-Times-1) .* (-Times*0.5);
%   DelDisc(1) = 0;
%   
%   % Error Ei and derivative dEidRi
%   Ei = CFSet(i,:) * Disc;
%   dEidRi = CFSet(i,:) * (DelDisc.*RateMap(:,i));
%   
%   % Compute Newton update
%   DeltaX = -Ei/dEidRi;
%   
%   if ( ~isreal(DeltaX) | (Iter > MaxIter) )
%     % exit the iteration with a failure
%     warning(sprintf('Could not solve for the %d rate\n',i));
%     break;
%   end
%   
%   % update the iteration
%   X = X + DeltaX;
%   Iter = Iter + 1;
%   
%   % compute convergence criteria
%   DelX = abs(DeltaX);
%   DelFun = abs(Ei);
% 
% end % end of Newton-Raphson iteration
% 
% % Assign the output
% Ri = X;
%
%  =======================================================================
%  Iterative approach Method 2: Using optimization tlbx
%  =======================================================================
% save zzz CFSet Times RateMap EndRates
% % Options for FSOLVE
% fsolveOpt = optimset('Jacobian','on', 'Display','iter', ...
%                      'TolFun',1e-14,  'TolX',1e-12, ...
%                      'MaxIter', 20);
% 
%   % Solve the equations one at a time with funfun
%   for j=1:NumPoints, 
%     EndRates(j) = fsolve('zbs1',EndRates(j),fsolveOpt, ...
%                          EndRates, CFSet, Times, RateMap, j)
%   end
% 
% end


