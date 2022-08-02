function [QtdFutPrice, AccrIntEnd] = tfutpricebyrepo(varargin)
%TFUTPRICEBYREPO Future price of T-bond.
%   This function computes theoretical futures bond price given settlement 
%   price, repo/funding, and reinvestment rate.
%
%   [QtdFutPrice AccrInt] = tfutpricebyrepo(RepoData, ReinvestData, Price, ...
%       Settle, MatFut, CF, CouponRate, Maturity)
%
%   Inputs:
%       RepoData - [Nx2] matrix of simple term repo/funding rate in decimal and
%                  their bases in the form:
%
%                  [RepoRate RepoBasis]
%                    
%                  Allowed RepoBasis values include:
%                     2 - actual/360 
%                     3 - actual/365
%
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
%          Price - [Nx1] vector of clean/quoted prices of T-bonds per $100 
%                  notional at settle.
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
%   QtdFutPrice - Quoted futures price, per $100 notional.
% 
%       AccrInt - Accrued Interest due at delivery date, per $100 notional.
%
%   Note:
%   Term Repo and Reinvestment rate input are simple rates on annual 
%    compounding.
%
%   Example: 
%   % Compute quoted futures price and accrued interest on target delivery date:
%
%   RepoData     = [0.020, 2];
%   ReinvestData = [0.018, 3];
%   Price        = [114.416; 113.171];
%   Settle       = '11/15/2002'; 
%   MatFut       = {'15-Dec-2002'; '15-Mar-2003'};
%   CF           = [1; 0.9854];
%   CouponRate   = [0.06; 0.0575];
%   Maturity     = {'15-Aug-2009'; '15-Aug-2010'};
% 
%   [QtdFutPrice AccrInt] = tfutpricebyrepo(RepoData, ReinvestData, ...
%       Price, Settle, MatFut, CF, CouponRate, Maturity)
%
%   QtdFutPrice =
%     114.1201
%     113.7090
%   AccrInt =
%       1.9891
%       0.4448

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.2.6.4 $  $Date: 2004/04/06 01:09:16 $

if nargin<8
    error('finfixed:tfutpricebyrepo:invalidNumberArguments', ...
        'Insufficient number of inputs.')
else
    RepoData  = varargin{1};
    
    if size(RepoData,2) ~= 2
        error('finfixed:tfutpricebyrepo:invalidSizeRepoData', ...
        'Incorrect size. RepoData must be matrix of two columns')
    end
    
    RepoRate  = RepoData(:,1);
    RepoBasis = RepoData(:,2);
    
    RinvData  = varargin{2};
    
    if size(RinvData,2) ~= 2
        error('finfixed:tfutpricebyrepo:invalidSizeReinvestmentData', ...
            'Incorrect size. RepoData must be matrix of two columns')
    end    
    
    RinvRate  = RinvData(:,1);
    RinvBasis = RinvData(:,2);
    
    Price = varargin{3}(:);
    SettleFut = datenum(varargin{4});
    MatFut = datenum(varargin{5});
    CF = varargin{6}(:);
    CouponRate = varargin{7}(:);
    Maturity = datenum(varargin{8});
    
end

% Resizing arguments
[RepoRate, RepoBasis, RinvRate, RinvBasis, Price, SettleFut, ...
    MatFut, CF, CouponRate, Maturity] = ...
finargsz(1, RepoRate, RepoBasis, RinvRate, RinvBasis, ...
    Price, SettleFut, MatFut, CF, CouponRate, Maturity);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                       
% Order integrity: SettleFut <= MatFut <= Maturity     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(SettleFut > MatFut)
    error('finfixed:tfutpricebyrepo:invalidSettle',...
          'Futures maturity must be greater than or equal to its settle')
end

if any(MatFut > Maturity)
    error('finfixed:tfutpricebyrepo:invalidMatFut',...
        'Bond maturity must be greater than or equal to its settle')
end

if any(RepoBasis ~=2 & RepoBasis ~= 3)
    error('finfixed:tfutpricebyrepo:invalidRepoBasis',...
        'Repo Basis must be 2 (ACT/360) or 3 (ACT/365)')
end

if any(RinvBasis ~=2 & RinvBasis ~= 3)
    error('finfixed:tfutpricebyrepo:invalidReinvestmentBasis', ...
        'Reinvestment Basis must be 2 (ACT/360) or 3 (ACT/365)')
end

idxRepo2 = find(RepoBasis == 2);
idxRepo3 = find(RepoBasis == 3);
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
%   Relevant bond information                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute beginning period and ending period accried interest
AccrIntBgn = -CFlowAmounts(:,1);

% Computing bond cash price
CashPrice = Price + AccrIntBgn;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Computing Cost basis                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
denomCost = 360 * ones(length(SettleFut),1);
denomCost(idxRepo3) = 365;

Cost = CashPrice .* (1 + RepoRate .* (MatFut-SettleFut) ./ denomCost);

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

% Revenue from reinvesting coupons
RevEIRC = CpnMatrix .* ...
    RinvRate(:, ones(numcol-1,1)) .* ...
        CDate2MatFut ./ denomRev(:, ones(numcol-1,1));

RevEIRC = sum(RevEIRC,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Computing Delivery Cash Price                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CashFutPrice = Cost - RevCpn - RevEIRC;

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
AccrIntEnd = 100*(numend./denomend) .* CouponRate/2;

% Assign result to output
QtdFutPrice = (CashFutPrice - AccrIntEnd) ./ CF;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% [EOF]
