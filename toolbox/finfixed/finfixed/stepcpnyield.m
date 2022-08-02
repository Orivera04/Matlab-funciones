function YTM = stepcpnyield(varargin)
%STEPCPNYIELD Yield-to-Maturity of stepped-coupon bonds.
%   Calculates yields on stepped-coupon bonds.
%
% Yield = stepcpnyield(Price, Settle, Maturity, ConvDates, ...
%       CouponRates)
%
% Yield = stepcpnyield(Price, Settle, Maturity, ConvDates, ...
%       CouponRates, Period, Basis, EndMonthRule, Face)
%
% Inputs:
%        Price - NSTPx1 vector of clean prices of the 
%                stepped coupon bonds.
%
%       Settle - NSTPx1 vector of settlement dates 
%                of the bonds in serial dates.
%
%     Maturity - NSTPx1 maturity dates for each bond 
%                in the portfolio.
%
%    ConvDates - Matrix(*) of NSTP x max(NCONV) containing
%                conversion dates AFTER Settle.
%
%  CouponRates - Matrix(*) of NSTP x max(NCONV+1) containing
%                coupon rates for each bond in the portfolio 
%                in decimal form. First column of this matrix
%                contains rates applicable between Settle and 
%                dates in the first column of ConvDates.
%                
%   (*)ConvDates MUST HAVE 1 (one) less column than CouponRates.
%      A diagram to illustrate the above description:
%
%   Settle-----------ConvDate1------------ConvDate2-----------Maturity
%           CpnRate1            CpnRate2             CpnRate3                  
%     
%   If first column of ConvDates, ConvDate1, equals Settle, 
%   then CpnRate1 will have NO effect. 
%   At the event that there is bond with different number of 
%   conversion dates, the shorter schedule will need to be 
%   padded with NaN.
%       
%  Optional Inputs:
%       Period - NSTPx1 vector of coupon payments frequency per year in 
%                integer form; 
%                 0 - zero coupon payments
%                 1 - annual coupon payments
%                 2 - semi-annual coupon payments  (default)
%                 3 - three coupon payments per year
%                 4 - quarterly coupon payments
%                 6 - semi-monthly coupon payments
%                12 - monthly coupon payments
%
%        Basis - NSTPx1 vector of values specifying the basis 
%                for each bond. Possible values are:
%                0 - actual/actual   (default)
%                1 - 30/360
%                2 - actual/360
%                3 - actual/365
%
% EndMonthRule - NSTPx1 vector of values specifying whether or 
%                not "end of month rule" is in effect for each bond.
%                0 - off
%                1 - on  (default)
%
%         Face - NSTPx1 vector of face value of each bond. Default is $100
%
% Outputs:
%        Yield - Yield-to-Maturity in decimal.
%
% Example:
%
% % This is an example to find YTM of a stepped coupon 
% % of known prices, given three scenarios:
% % 
% % A. Two Conversion, the first one however, 
% %    falls on Settle and thus immediately expires.
% %
% % B. Three Conversions, with conversion dates
% %    exactly on the CouponDates.
% %
% % C. Three Conversions, with one or more conversion dates
% %    not on CouponDates.
% % 
% % The last case illustrates that only cash flows after 
% % conversion dates are affected.
%
% Price = [117.3824;113.4339;113.4339];
% Settle   = datenum('02-Aug-1992');
% 
% ConvDate = [datenum('02-Aug-1992'), datenum('15-Jun-2003'), nan;
%             datenum('15-Jun-1997'), datenum('15-Jun-2001'), datenum('15-Jun-2005');
%             datenum('14-Jun-1997'), datenum('14-Jun-2001'), datenum('14-Jun-2005')];
%         
% Maturity = datenum('15-Jun-2010');
% 
% CouponRates = [0.075 0.08875 0.0925 nan;
%                0.075 0.08875 0.0925 0.1;
%                0.075 0.08875 0.0925 0.1];
% Basis = 1;
% Period = 2;
% EndMonthRule = 1;
% Face = 100;
% 
% YTM = stepcpnyield(Price, Settle, Maturity, ConvDate, ...
%      CouponRates, Period, Basis, EndMonthRule, Face)
%
% References: This function adheres to SIA 
%             Fixed Income Securities Formulas for Price, Yield, and 
%             Accrued Interest.

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.5.6.4 $   $Date: 2004/04/06 01:09:07 $

if nargin < 5
    error('finfixed:stepcpnyield:invalidInputs','Not enough input, need Yield, Settle, Maturity, ConvDate, and CouponRates');
end

Price = varargin{1};
Price = Price(:);

data(3:4) = varargin(2:3);

if nargin < 6 || isempty(varargin{6})
    data{5} = 2;
else
    data{5} = varargin{6};
end

if nargin < 7 || isempty(varargin{7})
    data{6} = 0;
else
    data{6} = varargin{7};
end

if nargin < 8 || isempty(varargin{8})
    data{7} = 1;
else
    data{7} = varargin{8};
end

if nargin < 9 || isempty(varargin{9})
    data{12} = 100;
else
    data{12} = varargin{9};
end

[CouponRate, Settle, Maturity, Period, Basis, ...
   EndMonthRule, IssueDate, FirstCouponDate, ...
     LastCouponDate, StartDate, Face] = instargbond(data{2:end});

% The scalar expansion done inside instargbond may not be 
% correct since it doesn't consider "Yield". Make another
% scalar expansion to make sure sizes are appropriate.
[CouponRate, Settle, Maturity, Period, Basis, ... 
   EndMonthRule, IssueDate, FirstCouponDate,...
  LastCouponDate, StartDate, Face, Price] = ...
   finargsz(1, CouponRate, Settle, Maturity, Period, ...
  Basis, EndMonthRule, IssueDate, FirstCouponDate, ...
   LastCouponDate, ones(size(varargin{5},1),1), Face, Price);

% Now parsing ConvDates and CouponRates
ConvDates   = varargin{4};
CouponRates = varargin{5};

% Checking the size
[convdaterow, convdatecol] = size(ConvDates);
[cpnraterow,  cpnratecol]  = size(CouponRates);

if (convdaterow ~= cpnraterow) || (convdatecol ~= (cpnratecol-1))
  error('finfixed:stepcpnyield:invalidSizeConvDataCpnRate',['Sizes of ConvDate and CouponRates are not correct', sprintf('\n'),... 
         'They both must have the same number of rows, ',...
         'but CouponRate must have one more column'])
end

if (convdaterow ~= length(Settle))
  error('finfixed:stepcpnyield:invalidConvDataCpnRateMatrix',['Not enough data in ConvDate and/or CouponRates matrices', ...
         ' corresponding to the number of Bonds being specified'])
end

% Use any number to parse inputs other than ConvDates and CouponRates
Anynumber = 0.1;
[AA, checkcouponmatrix] = cfamounts(Anynumber,Settle, Maturity, ...
    Period, Basis, EndMonthRule, [], [], [], [], Face);

% If any the first ConvDates falls on Settle:
% eliminate the first ConvDates by shifting to the left by one element
idxConvOnSettle = find(ConvDates(:,1) == Settle);

tempCpn  = [CouponRates(idxConvOnSettle,2:end), nan*zeros(length(idxConvOnSettle),1)];
tempConv = [ConvDates(idxConvOnSettle,2:end), nan*zeros(length(idxConvOnSettle),1)];

CouponRates(idxConvOnSettle,:) =  tempCpn;
ConvDates(idxConvOnSettle,:) = tempConv;

% if size is OK, Pad the first column of ConvDates with Settle
ConvDates(:,2:end+1) = ConvDates(:,1:end);
ConvDates(:,1) = Settle;

% now find out column index of each row where the last coupon 
% switch occurs for each bond
notnanmap = ~isnan(CouponRates).*ConvDates;

% the maximum is the latest valid dates times logical ones of 
% the non-nans
[maxnotnanmap, idxnotnan] = max(notnanmap,[],2);

NBonds = length(Settle);

%%%%%%%%%%%% CASH FLOW LAYOUT FOR REGULAR AND IRREGULAR %%%%%%%%%%
%                                                                %
% First get the quasi flows, then subtract face from all         %
% quasi maturity, and adjust quasi timefactors to actual         %
% time factors. Next reshape the matrices of cashflows           %
% and time factors into a vector.                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use semi-anual compounding frequency for yields-to-maturity (BEY)
Frequency = 2*ones(NBonds,1);

% Start out with NaN
PerDisc = NaN*ones(NBonds,1);
Iterations = NaN*ones(NBonds,1);

% Initial Guess for the discount based on Yield = average of CouponRates
XGuess = ones(NBonds,3);

% Calculation tolerances and maximum iterations
TolPRel = 1e-12;
TolXRel = 1e-12;
TolXAbs = 1e-12;
MaxIterations = 50;

for i = 1:NBonds       
    % Now this is the tough part, looking for QuasiMaturity that are
    % all immediately after ConversionDates.
    QuasiMaturity = [];
    
    for j = 2:idxnotnan(i)        
        dtc = checkcouponmatrix(i,:)-ConvDates(i,j);        
        QuasiMaturity(j-1) = min(checkcouponmatrix(i,min(find(dtc>=0))));
    end
    
    QuasiMaturity(end+1) = Maturity(i);
    QuasiSettle = [ConvDates(i,1), QuasiMaturity(1:end-1)];  %row vector    
    
    [CFlowAmounts, CFlowDates, TFactors] = ...
        cfamounts(CouponRates(i,1:idxnotnan(i)), ...
      QuasiSettle, QuasiMaturity, Period(i), Basis(i), ...
        EndMonthRule(i), [], [], [], [], Face(i));
    
    adjustTFactors = 0;
    
    %[principal, idxcol] = max([~isnan(CFlowAmounts).*CFlowDates],[],2);
    idxcol = sum(~isnan(CFlowAmounts), 2);
    
    for j = 1:length(QuasiSettle)-1 
        %take out the Face out of "quasi" maturities only
        CFlowAmounts(j,idxcol(j)) = CFlowAmounts(j,idxcol(j)) - Face(i);
        %calculate a continuous adjustment to the first set of coupon rate cash flow
        adjustTFactors(j+1) = adjustTFactors(j) + TFactors(j,idxcol(j)); 
    end
    
    adjustTFactors = adjustTFactors';
    adjustTFactors = adjustTFactors(:,ones(size(TFactors,2),1));
    TFactors = TFactors + adjustTFactors;        
    
    %Change all nans into zeros to facilitate computation
    CFlowAmounts(isnan(CFlowAmounts)) = 0;
    TFactors(isnan(TFactors)) = 0;
    
    %reshape the matrix into a row vector
    CFlowAmounts = reshape(CFlowAmounts',1,numel(CFlowAmounts)); 
    CFlowAmounts(1) = CFlowAmounts(1) - Price(i);
    TFactors     = reshape(TFactors',1, numel(TFactors));       
    
    % Initial Guess for the discount based on Yield = Coupon Rate
    % Allow backup initial Guesses
    XGuess(:,1) = 1./( 1 + mean(CouponRates(i,:))./Frequency );
    
    % Second guess for very high yields
    % Insure X^max(T) > 100*eps
    XGuess(:,2) = max(100*eps, (100*eps).^( 1./max(TFactors,[],2) ));
    
    % Third guess for very low yields
    XGuess(:,3) = 1;
    
    NumStarts = size(XGuess,2);      
    
    % Stopping parameters
    CMax = max(abs(CFlowAmounts));
    
    % Try different initial guesses if the first fail to converge
    for jStart = 1:NumStarts
        
        % Initial values
        X = XGuess(i,jStart);
        k = 1;
        
        XAbs = Inf;
        XRel = Inf;
        PRel = Inf;
        % Enforce all stopping conditions (not any)
        while( ( XAbs > TolXAbs ) || ( XRel > TolXRel ) || ( PRel > TolPRel ) )
            
            % compute guess update
            
            PV    = sum( CFlowAmounts .* (X.^TFactors) );
            dPVdX = sum( CFlowAmounts .* (X.^(TFactors-1)) .* TFactors );
            
            DeltaX = -PV/dPVdX;
            
            if ( ~isreal(DeltaX) || k > MaxIterations )
                % exit the iteration with failure
                X = NaN;
                break;
            end
            
            % update the iteration
            X = X + DeltaX;
            k = k + 1;
            
            % convergence criteria
            XAbs = abs(DeltaX);
            XRel = abs(DeltaX/X);
            PRel = abs(PV/CMax);
            
        end % end of Newton-Raphson Iteration
        
        if ~isnan(X)
            % don't start again if an answer was found
            break;
        end
        
    end % loop back and try another starting guess
    
    % assign result to PerDisc
    PerDisc(i) = X;
    Iterations(i) = k - 1;
end

%----------------------------------------------------------------------
% Compute Yield from the periodic discount factors
%----------------------------------------------------------------------
YTM = ( 1./PerDisc - 1 ).*Frequency;


% [EOF]
