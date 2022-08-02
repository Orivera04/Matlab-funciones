function [QtdFutPrice, AccrIntEnd] = tfutbyprice(varargin)
%TFUTBYPRICE Future prices of T-bonds given spot curve and price.
%   Price of N number of T-bond futures given a spot curve and bond prices.
%
%   [QtdFutPrice, AccrInt] = tfutbyprice(SpotCurve, Price, SettleFut, ...
%       MatFut, CF, CouponRate, Maturity)
%
%   [QtdFutPrice, AccrInt] = tfutbyprice(SpotCurve, Price, SettleFut, ...
%       MatFut, CF, CouponRate, Maturity, Interpolation)
%
%   Optional Inputs: Interpolation
%
%   Inputs:
%    SpotCurve - [Nx2 or Nx3] matrix. 
%
%                [SpotDates, SpotRates]
%                or
%                [SpotDates, SpotRates, CompoundingScheme]
%
%                The spot rates must be quoted as semi-annual compounding (2), 
%                when the third column is not supplied.
%               
%                If the third column is supplied, the allowed compounding
%                values are:
%                    1 - annual compounding
%                    2 - semi-annual compounding (default)
%                    3 - compounding three times per year
%                    4 - quarterly compounding
%                   12 - monthly compounding
%                   -1 - continuous compounding
%
%        Price - [Nx1] vector of prices (per $100 notional) at settlement date.
%
%    SettleFut - [Nx1] vector of identical elements containing settlement
%                date of futures contract. This is the date where valuation
%                is conducted.
%             
%       MatFut - [Nx1] vector of maturity dates of futures contracts (or
%                anticipated delivery dates). 
%              
%           CF - [Nx1] vector of Conversion Factors. 
%
%   CouponRate - [Nx1] vector of underlying bond's annual coupon rates in 
%                decimal.
%  
%    Maturity - [Nx1] vector of the underlying bond maturities.
%     
%   Optional Inputs:
%   Interpolation - Interpolation method.
%                   0 - nearest
%                   1 - linear (default)
%                   2 - cubic                  
%
%   Outputs:
%   QtdFutPrice - Quoted futures price, per $100 notional.
% 
%       AccrInt - Accrued Interest due at delivery date, per $100 notional.
%
%   Example:
%   % Constructing spot curve from Nov 14, data
%   Bonds = [datenum('02/13/2003'),        0;
%            datenum('05/15/2003'),        0;
%            datenum('10/31/2004'),  0.02125;
%            datenum('11/15/2007'),     0.03;
%            datenum('11/15/2012'),     0.04;
%            datenum('02/15/2031'),  0.05375];
% 
%   Yields  = [1.20; 1.25; 1.86; 2.99; 4.02; 4.93] / 100;     
% 
%   Settle = '11/15/2002';                  
% 
%   [ZeroRates, CurveDates] = zbtyield(Bonds, Yields, Settle);
%
%   SpotCurve = [CurveDates, ZeroRates];
% 
%   % Calculating a particular bonds future quoted price
%   RefDate         = {'1-Dec-2002'; '1-Mar-2003'};
%   MatFut          = {'15-Dec-2002'; '15-Mar-2003'};
%   Maturity        = {'15-Aug-2009'; '15-Aug-2010'};
%   CouponRate      = [0.06;0.0575];
%   CF              = convfactor(RefDate, Maturity, CouponRate);
%   Price           = [114.416; 113.171];
%   Interpolation   = 1;
% 
%   [QtdFutPrice, AccrInt] = tfutbyprice(SpotCurve, Price, ...
%       Settle, MatFut, CF, CouponRate, Maturity, Interpolation)
%
%   QtdFutPrice =
%     113.8129
%     112.4986
%   AccrInt =
%       1.9891
%       0.4448
%
%   QtdFutPrice is comparable to the closing prices of 113.93 and 112.68. 
%   However, differences are expected due to the nature of the contract and 
%   because the data cannot be directly compared.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.5.6.4 $  $Date: 2004/04/06 01:09:13 $

if nargin<7
    error('finfixed:tfutbyprice:invalidInputs','Not enough input arguments. Try "help tfutbyprice".')
else
    
    SpotRateData  = varargin{1};    
    spotcol = size(SpotRateData,2);
    
    if spotcol < 3
        if spotcol<2
            error('finfixed:tfutbyprice:invalidSpotCurve','Need at least 2 columns, [SpotDates , SpotRates]')
        else
            spotdates = datenum(SpotRateData(:,1));
            spotrates = SpotRateData(:,2);         
            spotcompn = 2*ones(size(spotrates));
        end
    else
        spotdates = datenum(SpotRateData(:,1));
        spotrates = SpotRateData(:,2); 
        spotcompn = SpotRateData(:,3);
    end
    
    Price      = varargin{2};
    SettleFut  = datenum(varargin{3});    
    
    % admit only sorted and unique set of forward rates
    [spotdates, m, n] = unique(spotdates);
    spotrates = spotrates(m);
    spotcompn = spotcompn(m);
    
    % check if spotrate data is obsolete
    if min(spotdates) < SettleFut(1)
        error('finfixed:tfutbyprice:invalidSpotRateDate','First spot rate data must be on, or after SettleFut')
    end
    
    % check that Settlement date is a scalar
    if any(SettleFut ~= SettleFut(1))
        error('finfixed:tfutbyprice:invalidSettleFut',['SettleFut is a Valuation Date,'...
                ' use scalar or vector of identical elements'])            
    end
    
    % appending the spot rate at Settle if not yet done
    % it is going to be equal to the shortest maturity
    % as measured from Settle.
    if min(spotdates) > SettleFut(1)
        spotdates(2:end+1) = spotdates;
        spotdates(1) = SettleFut(1);
        spotrates(2:end+1) = spotrates;
        spotcompn(2:end+1) = spotcompn;
    end
    
    MatFut     = datenum(varargin{4});    
    
    % check that the spot data covers the longest maturity
    if any(max(spotdates)<MatFut)
       error('finfixed:tfutbyprice:invalidSpotRateData',['Not enough SpotRateData. Please include spot rate up to:',... 
              sprintf('\n'), ...
              datestr(max(MatFut))])
    end
    
    CF         = varargin{5};
    CouponRate = varargin{6};
    
    if any(CouponRate<0)
        error('finfixed:tfutbyprice:invalidCouponRate',['Negative CouponRate detected, ',.... 
                'please check your inputs'])
    end
    
    Maturity   = datenum(varargin{7});
    
end

if nargin<8 | isempty(varargin{8})
    Interpolation = 1;
else
    Interpolation = varargin{8};
    
    if numel(Interpolation)-1
        error('finfixed:tfutbyprice:scalarInterpolation','Interpolation must be a scalar 0,1,or 2')
    end
    
    if (Interpolation < 0 | Interpolation > 2)
        error('finfixed:tfutbyprice:invalidInterpolation','Unknown interpolation method, try 0, 1, or 2')
    end
end

% Size expander.
[Price, SettleFut, MatFut, CF, CouponRate, Maturity] = ...
    finargsz(1, Price(:), SettleFut(:), MatFut(:), ...
    CF(:), CouponRate(:), Maturity(:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                       
% Order integrity: SettleFut <= MatFut <= Maturity     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(SettleFut > MatFut)
    error('finfixed:tfutbyprice:invalidMatFut','Futures maturity must be greater than or equal to its settle')
end

if any(MatFut > Maturity)
    error('finfixed:tfutbyprice:invalidMaturity','Bond maturity must be greater than or equal to its settle')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                     %
% Preliminary computation:                                            %
%                                                                     %
% a) compute beggining period accrued interest for bond cash price    %
% b) compute ending period accrued interest for futures quoted price  %
% c) spot curve to properly discount                                  %
%                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Construct cash flows, dates, and timings
[CFlowAmounts, CFlowDates, TFactors] = ...
    cfamounts(CouponRate, SettleFut, Maturity);

% Obtain size of CFlowDates
[numrow, numcol] = size(CFlowDates);

% vectorization would require that 
% vectors be turned into matrices.
MatFut = MatFut(:, ones(numcol,1));

% find the forward rates not quoted in semiannual
idxcont = find(spotcompn == -1);
spotrates(idxcont) = 2 * (exp(spotrates(idxcont)/2) - 1);

idxnottwo = find(spotcompn ~=2 & spotcompn ~= -1);
spotrates(idxnottwo) = ...
    2*( (1 + spotrates(idxnottwo) ./ spotcompn(idxnottwo)) .^ ...
        (spotcompn(idxnottwo)/2)  - 1 );

% To find cash flows that are within (<= MatFut and >=SettleFut)
irrelevant = find(CFlowDates > MatFut);

% Create copy of CFlowAmounts in CFAmounts
% but all cash flows after MatFut is assigned Nan values
CFDates = CFlowDates;
CFDates(irrelevant) = nan;
CFAmnts = CFlowAmounts;
CFAmnts(irrelevant) = nan;
TF      = TFactors;
TF(irrelevant)      = nan;

% Extract the last column index of intervening cash flows
[dummy, idxnotnan] = max(CFDates, [], 2);

% and also, exclude accrued interest - taken care later
CFDates = CFDates(:,2:end);
CFAmnts = CFAmnts(:,2:end);
TF      = TF(:,2:end);

% Computing/interpolating for appropriate continuously 
% compounded spotrate for intervening cash flows
switch Interpolation
case 0
    method = 'nearest';
case 1
    method = 'linear';
case 2
    method = 'cubic';
end

% Now just remeber that these SpotRates are continuously
% compounded.
SpotRates = interp1(spotdates, spotrates, CFDates', method)';

SpotatMatFut = interp1(spotdates, spotrates, MatFut(:,1));

% Compute the discounted values of intervening coupon values
discCFAmnts = CFAmnts .* (1+SpotRates/2).^-TF;
discCFAmnts(isnan(discCFAmnts)) = 0;
discCFAmnts = sum(discCFAmnts, 2);

% Compute beginning period and ending period accried interest
AccrIntBgn = -CFlowAmounts(:,1);

% Compute ending period accrued interest
% First must see if there is any intervening coupon
idxnoinsidecpn = find(idxnotnan==1);

% Then for these bonds we must find the previous coupon date
lastcpnbfrMatFut = ...
    CFlowDates(sub2ind([numrow, numcol], [1:numrow]', idxnotnan));

if ~isempty(idxnoinsidecpn)
   lastcpnbfrMatFut(idxnoinsidecpn) = ...
      cpndatepq(SettleFut(idxnoinsidecpn), Maturity(idxnoinsidecpn));
end

numend   = MatFut(:,1) - lastcpnbfrMatFut;

denomend = CFlowDates(sub2ind([numrow, numcol], [1:numrow]', ...
    idxnotnan+1)) - lastcpnbfrMatFut;

% AccrIntEnd is from $100 face
AccrIntEnd = 100*(numend./denomend) .* CouponRate/2;

% Computing bond cash price
CashPrice = Price + AccrIntBgn;

% Computing cash futures price
CashFut = (CashPrice - discCFAmnts) .* ...
    (1+SpotatMatFut/2).^-(2*(MatFut(:,1) - SettleFut) / 365) ;

% Assign result to output
QtdFutPrice = (CashFut - AccrIntEnd) ./ CF;


% [EOF]
