function Price = mbsoas2price(varargin)
%MBSOAS2PRICE Price of mortgage pool from OAS and a spot curve.
%   Price of NMBS number of mortgage pool given OAS, 
%   a spot curve, and prepayment vector.
%
% Price = mbsoas2price(ZeroRates, OAS, Settle, Maturity, ...
%   IssueDate, GrossRate)
%
% Price = mbsoas2price(ZeroRates, OAS, Settle, Maturity, ...
%   IssueDate, GrossRate, CouponRate, Delay, Interpolation, PrepaySpeed)
%
% Price = mbsoas2price(ZeroRates, OAS, Settle, Maturity, ...
%   IssueDate, GrossRate, CouponRate, Delay, Interpolation, [], PrepayMatrix)
%
% Inputs:
%        ZeroMatrix - Three-column matrix, the first is serial date,  
%                     the second contains Spot Rates with maturities 
%                     corresponding to the dates in the first column, 
%                     in decimal (e.g. 0.075), and the third column is 
%                     the Compounding of the rates given in the first 
%                     column.
%                     Allowable compounding are -1, 1,2,3,4,6,and 12.
%                     
%                     Example: [datenum('1-Jan-2003')  0.0154  12;
%                               datenum('1-Jan-2004')  0.0250  12;
%                               ......
%                               datenum('1-Jan-2020')  0.0675   2];
%
%               OAS - NMBSx1 vector of OAS in basis points.
%
%            Settle - NMBSx1 vector of settlement date. 
%                    
%          Maturity - NMBSx1 vector of maturity date.   
%                   
%         IssueDate - NMBSx1 vector of issue date.      
%                     
%         GrossRate - NMBSx1 vector of gross coupon rate, 
%                     in decimal.
%
% Optional Inputs:
%        CouponRate - NMBSx1 vector of Net Coupon Rate, 
%                     in decimal. 
%                     Default is equal to GrossRate. 
%              
%             Delay - NMBSx1 vector of delay in days.
%
%     Interpolation - Scalar value or NMBSx1 vector of IDENTICAL elements.
%                     Interpolation method,
%                     to compute for the corresponding spot rates for the 
%                     bond's cash flow. Default is (1), linear.
%                     Available methods are (0) nearest, (1) linear, and 
%                     (2) cubic spline.
%
%       PrepaySpeed - NMBSx1 vector of speed relative to 
%                     PSA standard. PSA standard is 100.
%                     Default is 0 (zero) prepayment speed.
%
%      PrepayMatrix - Customized prepayment vector. A matrix of size 
%                     [max(TermRemaining) x NMBS]. Missing values are
%                     padded with NaNs.  Each column corresponds to each
%                     MBS, and each row corresponds to each month after
%                     settlement. 
%
% Outputs:
%             Price - Clean price of passthrough per $100 face of 
%                     principal outstanding
%
% Example:
% % This demonstrates for PC sold at discount
% % increasing prepayment will increase its spread to benchmark
% % (and thus YTM).
%
% % Create zerorates
% Bonds = [datenum('11/21/2002')   0       100  0  2  1;    
%          datenum('02/20/2003')   0       100  0  2  1;
%          datenum('07/31/2004')   0.03    100  2  3  1;
%          datenum('08/15/2007')  0.035    100  2  3  1;
%          datenum('08/15/2012')  0.04875  100  2  3  1;
%          datenum('02/15/2031')  0.05375  100  2  3  1];
% 
% Yields = [0.0162;
%           0.0163;
%           0.0211;
%           0.0328;
%           0.0420;
%           0.0501];
% 
% % Since the above data is of the treasury
% % and not "selected" agency MBS, then an
% % ad-hoc method of altering the yield for 
% % the benchmark MBS was selected.
% 
% Yields = Yields + 0.025 * (1./[1:6]');
% 
% SpotCompounding = 2*ones(size(Yields));
%       
% %Get parameters from Bonds matrix
% 
% Settle       = datenum('20-Aug-2002');
% Maturity     = Bonds(:,1);
% CouponRate   = Bonds(:,2);
% Face         = Bonds(:,3);
% Period       = Bonds(:,4);
% Basis        = Bonds(:,5);
% EndMonthRule = Bonds(:,6);
% 
% [Prices, AccruedInterest] = bndprice(Yields, CouponRate, ...
%   Settle, Maturity, Period, Basis, EndMonthRule, [], [], [], [], Face);
% 
% [ZeroRatesP, CurveDatesP] = zbtprice(Bonds, Prices, Settle)
% ZeroMatrix = [CurveDatesP, ZeroRatesP, SpotCompounding];
% 
% OAS = [26.0502; 28.6348; 31.2222];
% Settle    = datenum('20-Aug-2002');
% Maturity  = datenum('02-Jan-2030');
% IssueDate = datenum('02-Jan-2000');
% GrossRate = 0.08125;
% CouponRate = 0.075;
% Delay = 14;
% Interpolation = 1;
% PrepaySpeed = [0 50 100];
% 
% Price = mbsoas2price(ZeroMatrix, OAS, Settle, Maturity, ...
%   IssueDate, GrossRate, CouponRate, Delay, Interpolation, PrepaySpeed)

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.7.6.3 $  $Date: 2003/10/23 12:15:17 $

if nargin <6
    error('finfixed:mbsoas2price:invalidInputs',['Need at least ZeroMatrix, ZVOAS,', sprintf('\n'),...
           'Settle, Maturity, IssueDate, and GrossRate'])
else
    % Required parameters
    ZeroRates = varargin{1};
    
    CurveDates = ZeroRates(:,1);
    SpotRates  = ZeroRates(:,2);
    RateCompounding = ZeroRates(:,3);
    
    % Make sure align these arrays into Column
    CurveDates = CurveDates(:);
    SpotRates = SpotRates(:);
    RateCompounding = RateCompounding(:);
    
    ZVOAS     = varargin{2}/10000; %turn BP to decimal
    Settle    = datenum(varargin{3});
    
    if any(Settle ~= Settle(1))
        error('finfixed:mbsoas2price:invalidSettle',['Please make sure that all Settle date are the same, ',...
               'or simply input a scalar Settle date'])
    end
        
    Maturity  = datenum(varargin{4});
    IssueDate = datenum(varargin{5});    
    GrossRate = varargin{6};    
end

if nargin <7 | isempty(varargin{7})
    CouponRate = GrossRate;
else
    CouponRate = varargin{7}(:);
end

if nargin <8 | isempty(varargin{8})
    Delay = 0;
else
    Delay = varargin{8}(:);
end

if nargin <9 | isempty(varargin{9})
    Interpolation = 1;
else
    Interpolation = varargin{9}(:);
    if any(Interpolation ~=Interpolation(1))
        error('finfixed:mbsoas2price:invalidInterpolation',['Please make sure that all Interpolation is of ONE type, ' ...
               'or simply input a scalar value for Interpolation'])
    end    
end

if nargin == 11;
    customized = 1;
else
    customized = 0;
end

if customized
    if ~isempty(varargin{10})
      error('finfixed:mbsoas2price:invalidPrePaySpeed',['Cannot use benchmark when supplying customized prepayment CPR.',... 
             sprintf('\n'),...
             'Put empty matrices ([]) for 10th input arguments'])
    end
        
    % check that prepayment is supplied and not empty.
    if isempty(varargin{11})
        error('finfixed:mbsoas2price:invalidPrePayMatrix',['Please supply a prepayment (SMM) matrix when',... 
               'you do not use benchmarked prepayment'])
    else
        SMMRel = varargin{11};
    end
    
   % Call mbscfamounts to get the Amounts and Time the cash flows 
   % occuring when customized prepayment is used
   [ZVOAS, Settle, Maturity, IssueDate, GrossRate, ...
        CouponRate, Delay, Interpolation] = ...
   finargsz(1, ZVOAS(:), Settle(:), Maturity(:), IssueDate(:), ...
        GrossRate(:), CouponRate(:), Delay(:), Interpolation(:));
   
   [CFlowAmounts dummy TFactors Factors crc_Maturity] = ...
       mbscfamounts(Settle, Maturity, IssueDate, ...
         GrossRate, CouponRate, Delay, [], SMMRel);
     
else
        
    if nargin < 10 | isempty(varargin{10})
        Speed = 0;
    else
        Speed = varargin{10};
    end
    
    [ZVOAS, Settle, Maturity, IssueDate, GrossRate, ...
         CouponRate, Delay, Speed, Interpolation] = ...
    finargsz(1, ZVOAS(:), Settle(:), Maturity(:), IssueDate(:), ...
         GrossRate(:), CouponRate(:), Delay(:), Speed(:), Interpolation(:));
    
    % Call mbscfamounts to get the Amounts and 
    % Time the cash flows occuring when std benchmark used   
    [CFlowAmounts dummy TFactors Factors crc_Maturity] = ...
        mbscfamounts(Settle, Maturity, IssueDate, ...
            GrossRate, CouponRate, Delay, Speed);
end

% Check Settle-Maturity vs Spot Dates consistency
% The case with "outdated" Spot Curve
if any(Settle > min(CurveDates))
    error('finfixed:mbsoas2price:invalidSpotCurve',['Settle is less than the earliest point in the Spot curve.',...
           sprintf('\n') ... 
           'The Spot Curve is outdated.'])
end

% The case with insufficient "length" of spot rates
if any(crc_Maturity > max(CurveDates))
    error('finfixed:mbsoas2price:invalidMaturity',['Maturity must be both within CurveDates to', sprintf('\n'), ...
          'discount Maturity cashflow, thus Maturity <= max(CurveDates)'])
end

% the corrected Maturity will avoid "odd" coupons in MBS by force.
% so this scheme of direct concatenation has NO risk of failing.
mbsdates = cfdates(Settle, crc_Maturity, 12);
mbsdates = [datenum(Settle), mbsdates];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If the zero rates are not monthly compounded    %
% then it is first changed to monthly compounding %
% THEN interpolated                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% convert the spotrates into a monthly compounding:

for i = 1:length(SpotRates)
    if RateCompounding(i)~=12
        
        if RateCompounding(i) == -1
            SpotRates(i) = 12*(exp(SpotRates(i)/12) - 1);
        else
            % This is where OutputCompoundingFORWARD 
            % could replace Output Compounding the old code
            SpotRates(i) = 12 * ...
                ((1 + SpotRates(i)/RateCompounding(i)).^...
                   (RateCompounding(i)/12) - 1);
        end        
    else
        % do nothing. Rate is on monthly compounding already.
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Once interpolated, the spotcurve is flat until    % 
% the first CurveDates.                             %
% See, for example, below:                          %
%                                                   %
%                                      *            %
%                       *                           % 
%               *                                   %
%           *                                       % 
% *.......*                                         %
% Notice that the spot rate values in ......        %
% applies to the cash flow between first CurveDates %
% and first cash flow date of the bond, usually     %
% Settlement                                        %
%                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CurveDates(2:end+1) = CurveDates;
% Since expansion of Settle is artificial, then
% it is fine just to take any of Settle, such as Settle(1)
CurveDates(1) = Settle(1);

SpotRates(2:end+1) = SpotRates;
SpotRates(1) = SpotRates(2);

% make sure again that we do not duplicate Settle if it's already
% there:
[CurveDates, midx] = unique(CurveDates);
SpotRates = SpotRates(midx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% interpolate for the spot rates on Cashflow dates            %
% INTERP1 handles matrix as long as it is Column oriented     %
% thus one must transpose mbsdates, which is Row oriented.    %
% to interpolate properly for each bond                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch Interpolation(1)
case 0
    spotrates = ...
        interp1(CurveDates, SpotRates, mbsdates', 'nearest');
case 1
    spotrates = ...
        interp1(CurveDates, SpotRates, mbsdates', 'linear');
case 2
    spotrates = ...
        interp1(CurveDates, SpotRates, mbsdates', 'cubic');
end

% Transpose spotrates once done interpolating
spotrates = spotrates';

[NumMBS NumCF] = size(CFlowAmounts);

% Expand the vector of zvoas
% and use it to compute discounts of each cash flow
Disc = 1./(1 + spotrates/12 + ZVOAS(:, ones(NumCF,1)));

dcf = CFlowAmounts .* Disc .^ TFactors;
dcf(isnan(dcf)) = 0;

% Remember to return Clean Price per $100 principal outstanding
Price = 100*sum(dcf,2);