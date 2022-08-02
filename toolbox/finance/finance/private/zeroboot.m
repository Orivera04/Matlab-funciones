function [ZeroRates, CurveDates] = zeroboot(Bonds, YieldsPrices, Settle,...
     OutputCompounding, OutputBasis, CallingFlag, MaxIterations)
%ZEROBOOT Derivation of a Zero Curve from Coupon Bond Data Given Yield Using the
%     Bootstrap Method
%
%     This is a Private function callable only through the ZBOOTPRICE and ZBOOTYIELD
%     functions
%


%   Author(s): D. Eiler, J. Akao and C. Bassignani, 11-12-97 
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.7 $   $Date: 2002/04/14 21:52:12 $ 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check the number of arguments in
if (nargin < 7)
     error('Insufficient number of input arguments!')
end


%All further inputs parsing is done by the higher-level functions ZBOOTPRICE and ZBOOTYIELD

%Sort the bonds being passed in by maturity date and get the index
[Temp, DateInd] = sort(Bonds(:, 1));


%Sort the entire matrix by rows according to the sort index
Bonds = Bonds(DateInd, :);
YieldsPrices = YieldsPrices(DateInd);


%Get parameters from Bonds matrix
Maturity = Bonds(:, 1);
CouponRate = Bonds(:, 2);
Face = Bonds(:, 3);
Period = Bonds(:, 4);
Basis = Bonds(:, 5);
EndMonthRule = Bonds(:, 6);


%Check the calling flag to determine the content of the yields/prices field
%Check to see if ZEROBOOT is being called from the ZBOOTYIELD function
if (CallingFlag == 1)
     Yields = YieldsPrices;
end


%Check to see if ZEROBOOT is being called from the ZBOOTPRICE function
if (CallingFlag == 2)
     Prices = YieldsPrices;     
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Do scalar expansion on the settlement date
XSettle = Settle * ones(size(Maturity));


%Check to see if yields have been passed in; if so calculate price values
if (CallingFlag == 1)  
     %Call BNDPRICE to determine prices given yield
     [Prices, AccruedInterest] = bndprice(Yields, CouponRate, ...
         XSettle, Maturity, Period, Basis, EndMonthRule, [], [], ...
         [], [], Face);

end


%Check to see if prices have been passed in; if so calculate yield values
if (CallingFlag == 2)
     %Call yldbond to determine yield given price for all securities
     Yields = yldbond(XSettle, Maturity, Face, Prices, CouponRate, Period, ...
          Basis, MaxIterations, EndMonthRule);
     
     %Calculate accrued interest
     CFlowAmounts = cfamounts(CouponRate, XSettle, Maturity, ...
         Period, Basis, EndMonthRule, [], [], [], [], Face);
     AccruedInterest = - CFlowAmounts(:,1);
end


%Set dirty prices equal to the clean price plus acrued interst; the dirty price will
%be used in determining the present value of the cash flows of each synthetic par bond
DirtyPrices = Prices + AccruedInterest;


%Set the output compounding variable
f = OutputCompounding;


%Get the coupon cash flows for all the bonds in the portfolio
Frequency = Period;
Frequency(Period==0) = 2;
CoupCF = Face .* CouponRate ./ Frequency;

%Call the MAPCFDATES subroutine to create the vector containing all the cash flow dates
%for the portfolio and the index of each bond's cash flow dates within the overall
%matrix
[IndexMat,AllDates] = mapcfdates(Bonds, Settle);


%Get the total number of cash flows
NumCashFlows = length(AllDates);


%Preallocate the vector in which the interpolated zero rates will be strored
InterpZeros = zeros(NumCashFlows, 1);


%Build year equivalents
YearDates = yearfrac(Settle, AllDates, OutputBasis);


%List the unique maturity dates and the ending index for each set of dates
%bonds(UniqueInd) = CurveDates
[CurveDates, UniqueInd] = unique(Maturity);
NumUnique = length(CurveDates);


%Find the number of bonds landing on each unique date
NumAtDate = [UniqueInd(1); diff(UniqueInd)];


%Find the first and last bonds at each unique data
FirstBondAtDate = [1; UniqueInd(1 : end - 1) + 1 ];
LastBondAtDate = UniqueInd;
 
 
%Average the yields for bonds maturing on each unique date
AccYield = cumsum(Yields);
SumYields = [AccYield(UniqueInd(1)); diff(AccYield(UniqueInd))];

MeanYields = SumYields ./ NumAtDate;


%Convert maturites and unique maturities to units of years from settlement
YearMats = yearfrac(Settle, Maturity, OutputBasis);
UYearMats = YearMats(UniqueInd);
ZeroRates = zeros(NumUnique, 1);


%Bonds with the first unique maturity (CurveDates) are (1:UniqueInd(1))
ZeroRates(1) = MeanYields(1); 



%Collect cash flow dates which fall before the first unique maturity
FixedCFInds = find(AllDates <= CurveDates(1));


%Assign them the first yield value
InterpZeros(FixedCFInds) = ZeroRates(1);


%Keep track of the location of the latest InterpZero which has been
%calculated already.  Cash flows at dates AllDates(1:DoneInterpLoc)
%have corresponding zero rates.  Use this index in the bootstrap loop.
DoneInterpZeroLoc = FixedCFInds(end); 


%Find the number of cash flows for each bond
NumCFforBonds = sum(~isnan(IndexMat), 2);


%Loop over remaining unique maturity dates
for iud = 2 : NumUnique
     
     %Initialize the variable in which rates will be accumulated
     RateSum = 0;
  
%Loop over all bonds with the same maturity date and accumulate the zero rates
for jb = FirstBondAtDate(iud) : LastBondAtDate(iud)
     
     %Find the locations of this bond's cash flows
     CFInd = IndexMat(jb, 1 : NumCFforBonds(jb));
    
     %If this bond has a only one cash flow, its zero rate is its yield
     if (NumCFforBonds(jb) == 1)
          
          % Convert the yield from semi-annual to the output 
          % compounding frequency
          ConvYield = f * (((1 + Yields(jb) / 2) ^ (2 / f)) - 1);
          
          %Accumulate the converted rate
          RateSum = RateSum + ConvYield;
          
     else 
          %Find where the cash flows for this bond fall:
          %Type 1: cf date(s) are before AllDates(DoneInterpZeroLoc)
          %Type 2: cf date(s) are after AllDates(DoneInterpZeroLoc) and before
          %        the maturity date of this bond (synthetic par bond)

          %Select out the cash flow indices which are Type 2 (maybe empty)
          ParBondMatInd = CFInd((CFInd>DoneInterpZeroLoc) & ...
               (CFInd < CFInd(end)));
          
          %Use the synthetic par bond arbitrage argument to find intermediate zero rates
          %as needed (i.e. for all Type 2 situations)
          for kpb = ParBondMatInd
               
               %1 dollar unit
               Par = 1;
          
               %Coupon rate is equal to yield which is interpolated between yields
               %at unique maturity dates. (Yields to Maturity)
               CoupPay = interp1q(UYearMats, MeanYields, YearDates(kpb))/f;
          
               %Cash flow indices for the par bond maturing at AllDates(kpb)
               ParBondInd = CFInd(CFInd < kpb); 
       
               %Present value of coupon payments
               CoupPVs = CoupPay * ((1 + InterpZeros(ParBondInd)/f)) .^...
                    (-YearDates(ParBondInd)* f);
                        
               %Future zero maturity value to price ratio
               FZeroVal = (CoupPay + Par) ./ (Par - sum(CoupPVs));
       
               %Convert ratio to zero rate
               InterpZeros(kpb) = f *((FZeroVal .^ (1 ./ (YearDates(kpb)*f))) - 1);
          
          end %Using the theoretical par bond approach to fill gap
  
          %Find the present value of coupon payments
          PeriodDisc = ((1 + InterpZeros(CFInd(1 : end - 1))/f));
          
          %Find the number of periods
          Periods = YearDates(CFInd(1 : end - 1))*f;
          
          %Find the present value of the coupons
          CoupPVs = CoupCF(jb)* PeriodDisc .^ ( - Periods);  
  
          %Find the future zero maturity value to price ratio
          FZeroVal = (CoupCF(jb) + Face(jb)) ./ (DirtyPrices(jb) - sum(CoupPVs));
       
          %Convert ratio to zero rate
          ThisZero = f*( (FZeroVal.^(1./(YearMats(jb)*f))) - 1 );
          
          %Accumulate the rates
          RateSum = RateSum + ThisZero;
          
     end %If branch for bond with multiple cash flows
     
end %End of loop over bonds with the same maturity date
 
%Average the Zero Rates for this maturity date
ZeroRates(iud) = RateSum ./ NumAtDate(iud);

%Interpolate zero rates to all cash flows before this maturity date
InterpInds = DoneInterpZeroLoc+1:CFInd(end);


%Interpolate the zero rates as needed
InterpZeros(InterpInds) = interp1q(UYearMats(1:iud), ZeroRates(1:iud), ... 
      YearDates(InterpInds));
 
%Find those interpolated zero rates which are now known
DoneInterpZeroLoc = InterpInds(end);


end %Loop over unique maturity dates


%Reshape the output
CurveDates = CurveDates(:);

ZeroRates = ZeroRates(:);



%end of ZEROBOOT function




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* SUBROUTINE FUNCTION(S)  **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [IndexByBond, AllDates] = mapcfdates(Bonds, StartDate)
%MAPCFDATES Derivation of a Vector of All Cash Flow Dates and Index for a Portfolio
%     of bonds
%
%     This function is a subroutine of the ZEROBOOT function is not meant to be called
%     independently
%

if (size(Bonds, 2) < 6)
   error('Bonds matrix must have 6 columns!');
end


%Call CFDATES function to get all the cash flow dates for bonds in the portfolio
DateMat = cfdates(StartDate, Bonds(:, 1), Bonds(:, 4), Bonds(:, 5), Bonds(:, 6));


AnyNaN = any(any(isnan(DateMat)));

%Set NaN's to realmax to allow unique indexing
DateMat(isnan(DateMat)) = realmax;


%Find all unique cash flow dates and write them to a single vector
[AllDates, I, IndexList] = unique(DateMat);


%Find all the realmax entries
MaxIndex = max(IndexList);


if AnyNaN
  %Change the realmax entries back to NaN's
  IndexList( IndexList==MaxIndex ) = NaN;

  %Clip off realmax entry
  AllDates = AllDates(1:end-1);
end

%Get the index of cash flow dates on a bond by bond basis
IndexByBond = reshape(IndexList, size(DateMat));




