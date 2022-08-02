function varargout = narbmodel(varargin)
%NARBMODEL Helper function of Hull-White 1-factor normal model 
%  This function computes relevant parameter for Hull-White's
%  1-factor normal model. Reference is Hull's text on
%  Options and Derivatives, pp. 574-575.
%
% params = narbmodel(FwdRateData, SettleOpt, MatOpt, ...
%   CouponRate, Maturity, ShortRateParam)
%
% params = narbmodel(FwdRateData, SettleOpt, MatOpt, ....
%   CouponRate, Maturity, ShortRateParam, ...
%       Period, EndMonthRule, Interpolation)
%
% Inputs:           
%     FwdRateData - A two-column matrix containing forward
%                   rate information.
%
%                    1) Each of the first column element on 
%                    row i (Ti) will be the date when forward 
%                    rate started to apply. 
%                    2) The second is the annual rate applicable 
%                    between time Ti and Ti+1. (The last forward
%                    rate can be any value, the only needed data
%                    is its date).
%                    3) The third (optional), will specify what 
%                    compounding scheme is used for the rates.
%                    Default is 2 (semi-annual). It has a minor
%                    effect as the models will returns
%                    parameters based on continuous compounding
%                    suitable for no-arbitrage models. Allowable 
%                    values are -1,1,2,3,4,and 12.
%
% Forward rate at the settlement of options is assumed to be 
% that of the first entry.
%               
%      SettleOpt - NHWx1 vector of Settlement date 
%                  of Option
%
%         MatOpt - NHWx1 vector of Maturity Date 
%                  of Option
% 
%     CouponRate - NHWx1 vector of coupon rate of 
%                  underlying bond
%               
%       Maturity - NHWx1 vector of maturity date of 
%                  underlying bond.
%                  Can be on MatOpt at the earliest.
%
% ShortRateParam - Two-column matrix [a S] from Hull-White's 
%                  short rate model of 
%                  dr = ( f(t) - ar )dt + Sdz 
%                  You can use something like NARBFIT
%                  to estimate it.
%                   
% Optional Inputs:
%         Period - NHWx1 vector of number of coupon in 
%                  a year for the underlying bond.
%                  Default is 2 (semi-annual). Supported 
%                  values are 0,1,2,4,6,12. 0 is for zero
%                  coupon receiving principal at maturity.
% 
%   EndMonthRule - NHWx1 vector of end-of-month rule. 
%                  Default is 1 (on). Use 0 for (off).
% 
%  Interpolation - Scalar value for Interpolation method. 
%                  Default is 1 (linear).            
%                  Other possible values are 0 (nearest) 
%                  and 2 (cubic).
%
% Outputs:   
% Parameters relevant to Hull-White short rate model:
%
% Ahat and Bhat - Hull's model coefficients at each 
%                 coupon periods after options' maturity              
%
% P0_t          - Price of $1 maturing at options' maturity                                                
%
% P0_T          - Price of $1 maturing at each coupon dates   
%
% time0_t       - Corresponding actual time of P0_t        
%
% time0_T       - Corresponding actual time of P0_T        
%
% CFs           - CashFlows at each coupon date to maturity                                                        
%
% Example:
% FwdRateData = ...    
%    [datenum('16-Oct-2002'),   0.0179;
%     datenum('16-Jan-2003'),   0.0170;
%     datenum('16-Apr-2003'),   0.0176;
%     datenum('16-Jul-2003'),   0.0194;
%     datenum('16-Oct-2003'),   0.0220;
%     datenum('16-Jan-2004'),   0.0250;
%     datenum('16-Apr-2004'),   0.0280;
%     datenum('16-Jul-2004'),   0.0305;
%     datenum('16-Oct-2004'),   0.0328;
%     datenum('16-Jan-2005'),   0.0348;
%     datenum('16-Apr-2005'),   0.0366;
%     datenum('16-Jul-2005'),   0.0383];
% 
% SettleOpt  = datenum('16-Oct-2002');
% MatOpt     = datenum('16-Jan-2003');
% CouponRate = 0.06;
% Maturity   = datenum('16-Jan-2005');
% ShortRateParam = [0.05 0.015];
% Period = [0; 2] 
%
% [Ahat Bhat P0_t P0_T time0_t time0_T CFs] = ...
%     narbmodel(FwdRateData, SettleOpt, MatOpt, ....
%   CouponRate, Maturity, ShortRateParam, Period)
%
% Note that discount factor will be computed from 
% supplied forward rate information. Function such as
% BOOTSTRAPBYPRICE/YIELD, or LIBORFLOAT2FIXED are good
% sources for these forward rates.
%

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.5.6.3 $  $Date: 2004/04/06 01:09:02 $

if nargin<6
    error('finfixed:narbmodel:invalidInputs',['Not enough input parameters. ',...
           'Please type "help narbmodel" for more info'])
else
    FwdRateData = varargin{1};
    
    fwdcol = size(FwdRateData,2);
    
    if fwdcol < 3
      if fwdcol<2
         error('finfixed:narbmodel:invalidFwdRateData','Need at least 2 columns, [ForwardDates , ForwardRates]')
      else
         fwddates = datenum(FwdRateData(:,1));
         fwdrates = FwdRateData(:,2);         
         fwdcompn = 2*ones(size(fwdrates));
      end
    else
        fwddates = datenum(FwdRateData(:,1));
        fwdrates = FwdRateData(:,2); 
        fwdcompn = FwdRateData(:,3);
    end
    
    % admit only sorted and unique set of forward rates
    [fwddates, m, n] = unique(fwddates);
    fwdrates = fwdrates(m);
    fwdcompn = fwdcompn(m);
            
    SettleOpt   = datenum(varargin{2});
    
    if any(SettleOpt ~= SettleOpt(1))
        error('finfixed:narbmodel:invalidSettleOpt',['SettleOpt is a Valuation Date,'...
               ' use scalar or vector of identical elements'])            
    end
    
    % This section is necessary to guard against obsolete forward data
    % or, valuing so far ahead into the future.
    relevantfwddata = find(fwddates>=SettleOpt(1));
    
    if isempty(relevantfwddata)
        error('finfixed:narbmodel:irrelevantFwdRateData',['Irrelevant FwdRateData was supplied', sprintf('\n'),... 
              ' - There is no forward data found on or after SettleOpt'])
    else    
        fwddates = fwddates(relevantfwddata);
        fwdrates = fwdrates(relevantfwddata);
        fwdcompn = fwdcompn(relevantfwddata);
    end   
    
    % at this time check if fwdcompn is 1,2,3,4,12, or -1
    [dummy1 ia] = intersect(fwdcompn, [1 2 3 4 12 -1]);
    if ~isequal(ia,length(fwdcompn))
        error('finfixed:narbmodel:unsupportedFwdRateData','Unsupported forward rate compounding frequency')
    end
    
    MatOpt      = datenum(varargin{3});
    CouponRate  = varargin{4};
    Maturity    = datenum(varargin{5});
    
    % This section is necessary to guard against incomplete forward data
    if any(Maturity > fwddates(end))
        error('finfixed:narbmodel:incompleteFwdRateData',['Insufficient FwdRateData for specified Maturity, '... 
              '- please supply more ForwardRates'])
    end
    
    SRParam     = varargin{6};
    
    if size(SRParam,2)~=2
        error('finfixed:narbmodel:invalidShortRateParam','Short rate parameters must be a vector of 2 elements')
    end
    
    a = SRParam(:,1);
    S = SRParam(:,2);
end

if nargin<7 | isempty(varargin{7})
    Period = 2;
else
    Period = varargin{7};
end

if nargin<8 | isempty(varargin{8})
    EndMonthRule = 1;
else
    EndMonthRule = varargin{8};
end

if nargin<9 | isempty(varargin{9})
    Interpolation = 1;
else
    Interpolation = ceil(varargin{9});

    if numel(Interpolation)-1
        error('finfixed:narbmodel:scalarInterpolation','Interpolation must be a scalar 0,1,or 2')
    end
    
    if (Interpolation < 0 | Interpolation > 2)
        error('finfixed:narbmodel:invalidInterpolation','Unknown interpolation method, try 0, 1, or 2')
    end
end

% The 10th input argument pertains specifically to swap
% and will not be used by anything else.
if nargin<10 | isempty(varargin{10})
    FirstCouponDate = [];
else
    FirstCouponDate = datenum(varargin{10});
end

if ~isempty(FirstCouponDate) % only when there is swap
    [SettleOpt, MatOpt, CouponRate, Maturity, Period, ...
        EndMonthRule, a, S, FirstCouponDate] = ...
    finargsz(1, SettleOpt(:), MatOpt(:), CouponRate, ...
        Maturity(:), Period(:), EndMonthRule(:), a(:), S(:), ...
            FirstCouponDate(:));
else
    [SettleOpt, MatOpt, CouponRate, Maturity, Period, ...
        EndMonthRule, a, S] = ...
    finargsz(1, SettleOpt(:), MatOpt(:), CouponRate, ...
        Maturity(:), Period(:), EndMonthRule(:), a(:), S(:));
end

% Option Maturity cannot be less than its Settlement.
if any(MatOpt < SettleOpt)
    error('finfixed:narbmodel:invalidMatOpt','All option maturities must be on or after their settlement')
end
    
% Bond Maturity must be at least the same as that of the option.    
if any(Maturity < MatOpt)
    error('finfixed:narbmodel:invalidMaturity','Bond Maturity must be at or after option settlement')
end

%creating cashflows and the corresponding dates
[CFlowAmounts, CFlowDates] = ...
    cfamounts(CouponRate, SettleOpt, Maturity, ...
        Period, 0, EndMonthRule, [], FirstCouponDate);

% Exclude (negative) accrued interest to work with 
% dirty price only
CFlowAmounts = CFlowAmounts(:,2:end);
CFlowDates   = CFlowDates(:,2:end);

% size of Cash matrices
[numrow, numcol] = size(CFlowDates);
a = a(:,ones(numcol,1));
S = S(:,ones(numcol,1));

% Now we will exclude any date prior to MatOpt
% because they are irrelevant to European bonds.
% If it falls on coupon date, the coupon does not
% count as cash flow and thus the <= relation
% (This way, we will also avoid deltaT = 0, 
% which is a trivial problem.)
irrelevant  = find(CFlowDates <= MatOpt(:,ones(numcol,1)));
CFlowAmounts(irrelevant) = nan;
CFlowDates(irrelevant)   = nan;
[dummy FirstAfterMatIdx] = min(CFlowDates, [], 2);

% time scales:
% 0 - SettleOpt  : Settle of options
% t - MatOpt     : Maturity of options
% T - CFlowDates : cash flow dates of bond

% a convenient choice of deltaT is the time
% between maturity of option to the first coupon/cash flow
FirstAfterMatOpt = ...
    CFlowDates(sub2ind(size(CFlowDates), (1:numrow)', ...
        FirstAfterMatIdx));

deltaT = (FirstAfterMatOpt(:,ones(numcol,1)) - ...
    MatOpt(:,ones(numcol,1)) ) / 365.25;

% Time from option maturity to (zero) coupon maturity
T_t    = ( CFlowDates - MatOpt(:,ones(numcol,1)) ) / 365.25;

% Numerator to compute Bhat
Bt_T   = ( 1 - exp(-a .* (T_t)) )  ./ a;

% Denominator to compute Bhat
BdelT  = ( 1 - exp(-a .* deltaT) ) ./ a;

% Bhat
Bhat_T = Bt_T ./ BdelT .* deltaT;

% If it is not already, we'll set forwardrate 
% at settle equals first entry in FwdRateData
if fwddates(1) > SettleOpt(1)    
    fwddates(2:end+1)   = fwddates;
    fwddates(1)         = SettleOpt(1);
    fwdrates(2:end+1)   = fwdrates;
    fwdcompn(2:end+1)   = fwdcompn;
end

% find the forward rates not quoted in continuous compounding
% and convert that forward rate into continuous compounding.
idxnotcont = find(fwdcompn ~= -1);
fwdrates(idxnotcont) = fwdcompn(idxnotcont) .* ...
    log(1 + fwdrates(idxnotcont) ./ fwdcompn(idxnotcont));

% Convert the forward rates to zero rates, 
% quoted at continuous compounding
dfwddatestime  = [fwddates(2:end) - fwddates(1:end-1)]/365.25;

% time to forward rates as measured from option settlement
fwdtimefromset = [fwddates(2:end) - SettleOpt(1)] / 365.25;

% computing applicable spot rates for each period
fwddiscounts   = exp(-dfwddatestime .* fwdrates(1:end-1));
zerorates      = [fwdrates(1); ...
        (-1./fwdtimefromset) .* log(cumprod(fwddiscounts))];

switch Interpolation
case 0
    method = 'nearest';
case 1
    method = 'linear';
case 2
    method = 'cubic';
end

% interpolate zero rates:
% A) for the dates on CFlowDates
ZeroRates = interp1(fwddates, zerorates, CFlowDates', method)';
% and
% B) for MatOpt only:
zeros_t   = interp1(fwddates, zerorates, MatOpt, method);

% Price at time 0 for $1 maturing at T
time0_T = ( CFlowDates - SettleOpt(:,ones(numcol,1)) ) / 365.25;
P0_T    = exp(-ZeroRates .* time0_T);

% Price at time 0 for $1 maturing at t
time0_t = (MatOpt - SettleOpt) / 365.25;
P0_t    = exp(-zeros_t .* time0_t);
P0_t    = P0_t(:,ones(numcol,1));

% Price at time 0 for $1 maturing at t+deltaT 
% (really, the first coupon after MatOpt)
P0_tdeltaT = ...
    P0_T(sub2ind(size(P0_T), (1:numrow)', FirstAfterMatIdx));
P0_tdeltaT = P0_tdeltaT(:,ones(numcol,1));

% Computing Ahat
partA = log(P0_T ./ P0_t);
partB = (Bt_T ./ BdelT) .* log(P0_tdeltaT ./ P0_t);
partC = (S.^2 /4./a).*(1-exp(-2.*a.*time0_t(:,ones(numcol,1)))).*...
    Bt_T.*(Bt_T - BdelT);

Ahat_T = exp(partA - partB - partC);

% Assign to outputs:
varargout = {Ahat_T, Bhat_T, P0_t, P0_T, ...
        time0_t(:,ones(numcol,1)), time0_T, CFlowAmounts};
