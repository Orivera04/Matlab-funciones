function ImpliedRepo = tfutimprepo(varargin)
%TFUTIMPREPO Implied repo-rate of T-bonds.
%   This function computes implied repo rate that will prevent arbitrage of 
%   T-bond futures, given the clean price at settlement and a delivery date.
%
%   ImpliedRepo = tfutimprepo(ReinvestData, Price, QtdFutPrice, Settle, ...
%   MatFut, CF, CouponRate, Maturity)
%
%   Inputs:
%   ReinvestData - [Nx2] matrix of rates and bases for the reinvestment of
%                  intervening coupons in the form of:
%                  
%                  [ReinvestRate ReinvestBasis] 
%                  
%                  ReinvestRate is the simple reinvestment rate, in decimal. 
% 
%                  Allowed ReinvestBasis values include:
%                     0 - not reinvested
%                     2 - actual/360
%                     3 - actual/365
%
%          Price - [Nx1] vector of current bond price, per $100 notional.
%
%    QtdFutPrice - [Nx1] vector of quoted bond futures price, per $100 notional.
%
%         Settle - [Nx1] vector for settlement/valuation date of futures
%                  contracts.
%          
%         MatFut - [Nx1] vector of maturity dates of futures contracts (or
%                  anticipated delivery dates). 
%              
%             CF - [Nx1] vector of Conversion Factors. 
%
%     CouponRate - [Nx1] vector of underlying bond's annual coupon rates in 
%                  decimal.
%  
%       Maturity - [Nx1] vector of the underlying bond maturities.
%
%   Outputs:
%   ImpliedRepo - Implied annual repo rate, in decimal and with ACT/360 basis.
%
%   Example: 
%   ReinvestData = [0.018, 3];
%   Price        = [114.4160; 113.1710];
%   QtdFutPrice  = [114.1201; 113.7090];
%   Settle       = '11/15/2002'; 
%   MatFut       = {'15-Dec-2002'; '15-Mar-2003'};
%   CF           = [1; 0.9854];
%   CouponRate   = [0.06; 0.0575];
%   Maturity     = {'15-Aug-2009'; '15-Aug-2010'};
% 
%   ImpliedRepo = tfutimprepo(ReinvestData, Price, QtdFutPrice, ...
%       Settle, MatFut, CF, CouponRate, Maturity)
%
%   ImpliedRepo =
%       0.0200
%       0.0200

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.2.6.4 $  $Date: 2004/04/06 01:09:15 $

if nargin<8
    error('finfixed:tfutimprepo:invalidNumberArguments', ...
        'Insufficient number of inputs.')
else
    
    RinvData  = varargin{1};
    
    if size(RinvData,2) ~= 2
      error('finfixed:tfutimprepo:invalidSizeReinvestmentData', ...
        'Incorrect size. ReinvestmentData must be matrix of two columns')
    end    
    
    RinvRate  = RinvData(:,1);
    RinvBasis = RinvData(:,2);
    Price = varargin{2}(:);
    QtdFutPrice = varargin{3}(:);
    SettleFut = datenum(varargin{4});
    MatFut = datenum(varargin{5});
    CF = varargin{6}(:);
    CouponRate = varargin{7}(:);
    Maturity = datenum(varargin{8});
    
end

% Resizing arguments
[RinvRate, RinvBasis, Price, QtdFutPrice, SettleFut, ...
    MatFut, CF, CouponRate, Maturity] = ...
finargsz(1, RinvRate, RinvBasis, Price, QtdFutPrice, SettleFut, ...
    MatFut, CF, CouponRate, Maturity);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                       
% Order integrity: SettleFut <= MatFut <= Maturity     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(SettleFut > MatFut)
    error('finfixed:tfutimprepo:invalidSettle',...
          'Futures maturity must be greater than or equal to its settle')
end

if any(MatFut > Maturity)
    error('finfixed:tfutimprepo:invalidMatFut',...
        'Bond maturity must be greater than or equal to its settle')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                       
% Check that allowable reinvestment basis is ACT/360 and ACT/365   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(RinvBasis ~=2 & RinvBasis ~= 3)
    error('finfixed:tfutimprepo:invalidReinvestmentBasis', ...
        'Reinvestment Basis must be 2 (ACT/360) or 3 (ACT/365)')
end

idxRinv2 = find(RinvBasis == 2);
idxRinv3 = find(RinvBasis == 3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Finding Intermediate Coupons                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Construct cash flows, dates, and timings
[CFlowAmounts, CFlowDates, TFactors] = ...
    cfamounts(CouponRate, SettleFut, Maturity);

% Obtain size of CFlowDates
[numrow, numcol] = size(CFlowDates);

% To find cash flows that are within (<= MatFut and >=SettleFut)
irrelevant = find(CFlowDates > MatFut(:, ones(numcol,1)));

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Relevant current bond information                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute beginning period and ending period accried interest
AccrIntBgn = -CFlowAmounts(:,1);

% Computing bond cash price
CashPrice = Price + AccrIntBgn;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Computing Revenue basis                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% computing number of actual days between intervening
% coupons and end of repo / contract delivery
CDate2MatFut = MatFut(:, ones(numcol-1,1)) - CFDates;
CDate2MatFut(isnan(CDate2MatFut)) =0;

CpnMatrix = CFAmnts;
CpnMatrix(isnan(CpnMatrix))= 0;

% Revenue from intervening coupons 
RevCpn = sum(CpnMatrix,2);

% Revenue from reinvesting coupons
denomRev = 360 * ones(length(SettleFut),1);
denomRev(idxRinv3) = 365;

RevEIRC = CpnMatrix .* RinvRate(:, ones(numcol-1,1)) .* ...
    CDate2MatFut ./ denomRev(:, ones(numcol-1,1));

RevEIRC = sum(RevEIRC,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Computing Delivery Quoted/Clean Price                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
AccrIntEnd = 100*(numend ./ denomend) .* CouponRate/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Calculate Revenue side (RHS)                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RHS = (CF .* QtdFutPrice + AccrIntEnd + RevCpn + RevEIRC);

ImpliedRepo = (RHS ./ CashPrice - 1) * 360 ./ (MatFut - SettleFut);


% [EOF]
