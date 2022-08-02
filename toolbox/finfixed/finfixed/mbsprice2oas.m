function varargout = mbsprice2oas(varargin)
%MBSPRICE2OAS OAS given price, prepayment, and benchmark spot curve.
%   OAS for NMBS number of mortgage pool given price and prepayment
%   assumption and benchmark spot curve.
%
% OAS = mbsprice2oas(ZeroMatrix, Price, Settle, Maturity, ...
%   IssueDate, GrossRate)
%
% OAS = mbsprice2oas(ZeroMatrix, Price, Settle, Maturity, ...
%   IssueDate, GrossRate, CouponRate, Delay, ...
%       Interpolation, PrepaySpeed)
%
% OAS = mbsprice2oas(ZeroMatrix, Price, Settle, Maturity, ...
%   IssueDate, GrossRate, CouponRate, Delay, ...
%       Interpolation, [], PrepayMatrix)
%
% Inputs:
%        ZeroMatrix - Three-column matrix, the first is serial date,  
%                     the second contains Spot Rates with maturities 
%                     corresponding to the dates in the first column, 
%                     in decimal (e.g. 0.075), and the third column is 
%                     the Compounding of the rates given in the first 
%                     column.
%                     
%                     Example: [datenum('1-Jan-2003')  0.0154  12;
%                               datenum('1-Jan-2004')  0.0250  12;
%                               ......
%                               datenum('1-Jan-2020')  0.0675   2];
%
%             Price - NMBSx1 vector of clean price for every $100 
%                     face of bond issue.
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
%               OAS - Zero volatility OAS, in basis point (bp).
%
% Example:
% % This examples calculates OAS of 30-year fixed rate with about
% % 28 year WAM left given an assumption of 0, 50, and 100 PSA 
% % prepayment:
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
% % and not "selected" agency MBS, then a very
% % ad-hoc method of altering the yield for 
% % the benchmark MBS was selected for demo purposes
% 
% Yields = Yields + 0.025 * (1./[1:6]');
% 
% SpotCompounding = 2*ones(size(Yields));
%       
% %Get parameters from Bonds matrix
% 
% Settle = datenum('20-Aug-2002');
% Maturity     = Bonds(:,1);
% CouponRate   = Bonds(:,2);
% Face         = Bonds(:,3);
% Period       = Bonds(:,4);
% Basis        = Bonds(:,5);
% EndMonthRule = Bonds(:,6);
% 
% [Prices, AccruedInterest] = bndprice(Yields, CouponRate, ...
%       Settle, Maturity, Period, Basis, EndMonthRule, [], [], [], [], Face);
% 
% %ZBTPRICE
% [ZeroRatesP, CurveDatesP] = zbtprice(Bonds, Prices, Settle)
% 
% ZeroMatrix = [CurveDatesP, ZeroRatesP, SpotCompounding];
% 
% Price     = 95;
% Settle    = datenum('20-Aug-2002');
% Maturity  = datenum('02-Jan-2030');
% IssueDate = datenum('02-Jan-2000');
% GrossRate = 0.08125;
% CouponRate = 0.075;
% Delay = 14;
% Interpolation = 1;
% PrepaySpeed = [0; 50; 100];
% 
% OAS = mbsprice2oas(ZeroMatrix, Price, Settle, Maturity, ...
%    IssueDate, GrossRate, CouponRate, Delay, Interpolation, PrepaySpeed)

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision 1.3 $  $Date: 2004/04/06 01:08:56 $

if nargin <6
    error('finfixed:mbsprice2oas:invalidInputs',['Need at least ZeroMatrix, ', sprintf('\n'), ...
           'Price, Settle, Maturity, IssueDate, and GrossRate'])
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
    
    Price     = varargin{2}/100; %unit-ized the price
    Settle    = datenum(varargin{3});
    
    if any(Settle ~= Settle(1))
        error('finfixed:mbsprice2oas:invalidSettle',['Please make sure that all Settle date are the same, ' ...
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
      error('finfixed:mbsprice2oas:invalidInterpolation',['Please make sure that all Interpolation is of ONE type, ',...
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
      error('finfixed:mbsprice2oas:invalidPrePaySpeed',['Cannot use benchmark when supplying customized prepayment CPR.',...
             sprintf('\n'),...
             'Put empty matrices ([]) for 10th input arguments'])
    end
        
    % check that prepayment is supplied and not empty.
    if isempty(varargin{11})
        error('finfixed:mbsprice2oas:invalidPrePayMatrix',['Please supply a prepayment (SMM) matrix when',... 
               'you do not use benchmarked prepayment'])
    else
        SMMRel = varargin{11};
    end
    
   % Call mbscfamounts to get the Amounts and Time the cash flows 
   % occuring when customized prepayment is used
   [Price, Settle, Maturity, IssueDate, GrossRate, ...
        CouponRate, Delay, Interpolation] = ...
    finargsz(1, Price(:), Settle(:), Maturity(:), IssueDate(:), ...
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
    
    [Price, Settle, Maturity, IssueDate, GrossRate, ...
         CouponRate, Delay, Speed, Interpolation] = ...
     finargsz(1,Price(:), Settle(:), Maturity(:), IssueDate(:), ...
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
    error('finfixed:mbsprice2oas:invalidSpotCurve',['Settle is less than the earliest point in the Spot curve.', ...
           sprintf('\n'), ... 
           'The Spot Curve is outdated.'])
end

% The case with insufficient "length" of spot rates
if any(crc_Maturity > max(CurveDates))
    error('finfixed:mbsprice2oas:invalidMaturity',['Maturity must be both within CurveDates to', sprintf('\n'), ...
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

% Subtract price so OAS will make this NPV = 0
CFlowAmounts(:,1) = CFlowAmounts(:,1) - Price;
NumCF = size(CFlowAmounts, 2);

% OAS is initially guessed to be close to the "monthly" coupon
x0 = CouponRate/12;

% setting an option to suppress optimization results
options1 = optimset('Display','off');

% FSOLVE will iteratively solve for the value of OAS (X) that will make
% the price of the bond equal to given market clean price
X = fsolve(@mbsintfun, x0, options1, CFlowAmounts, ...
    TFactors, NumCF, spotrates);

% basis point is 10,000 times of OAS in decimal
varargout{1} = 10000*X;


function y = mbsintfun(x,CF,TF,b, spotrates)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
% OAS is calculated as the scalar value X satisfying            %
%                                                               %
% Price = sum ( CF(i) / (1 + spotmonthly(i)/12 + K)^TF(i))      %
%                                                               %
% Notice that CF includes AI (accrued interests) and            %
% spot monthly is monthly compounded spot rates                 %
% and the index i in our vectorized program is really a         %
% column vector operating on a nan-padded matrix of CF          %
% and TF for multiple passthroughs.                             %
% (This way we utilize the best MATLAB can do.)                 %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate and construct a discount matrix applicable to
% each and every predicted cash flows of the MBS
Disc = 1./(1+(spotrates+x(:, ones(b,1)))/12);

% Calculate discounted cash flows
dcf = CF .* (Disc.^TF);

% Prior to summing, change the Nan elements to zero
dcf(isnan(dcf))= 0;

% sum horizontally to obtain price
y = sum(dcf,2);
