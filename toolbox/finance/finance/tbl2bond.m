function [TBondMatrix, TBondEquivSettle] = tbl2bond(TBillMatrix)
%TBL2BOND Treasury Bill to Equivalent Treasury Bond Parameters.
%
%   [TBondMatrix, Settle] = tbl2bond(TBillMatrix)
%
%   Summary: 
%     This function takes market parameters for U.S. Treasury Bills
%     restates them in U.S. Treasury Bond form as zero coupon bonds. This
%     makes the T-Bills directly comparable to Treasury notes and bonds.
%
%   Inputs: 
%     TBillMatrix - Nx5 matrix containing the following column vectors
%       (all required):
%       Maturity - Nx1 column vector containing value representing the
%       maturity date of the T-Bills contained in the portfolio in
%       serial date number form
%       
%       DaysMaturity - Nx1 column vector containing values for the number of
%       days to maturity for each T-Bill in the portfolio in integer form.
%       Days to Maturity is quoted on a skip-day basis; the actual number
%       of days from settlement to maturity is DaysMaturity + 1.
%       
%       Bid - Nx1 column vector containing values for the bid bank discount
%       yield (the percentage discount from face value at which the
%       instrument would be bought by a dealer annualized on a simple
%       interest basis over a 360-day year)in decimal form
%       
%       Asked - Nx1 column vector containing values for the asked bank
%       discount yield in decimal form
%    
%       AskYield - Nx1 column vector containing the values, in decimal form,
%       for the bond-equivalent yield (i.e. the holding period return,
%       annualized on a simple interest basis and assuming a 365-day year)
%       that the investor will realize by purchasing the bill and holding
%       it to maturity
%
%   Outputs: 
%     TBondMatrix - Nx5 matrix containing the following column vectors:
%       CouponRate - Nx1 column vector containing the equivalent coupon
%       rate in which will be zero for all T-Bills since they are by
%       definition a zero coupon instrument (this is vector serves as
%       a placeholder in the matrix)
%
%       Maturity - Nx1 column vector containing the maturity date for each
%       T-Bill in serial date number form
%
%       Bid - Nx1 column vector containing the bid price for the T-Bill in
%       decimal form in terms of $100 of face value
%
%       Asked - Nx1 column vector containing the ask price for the T-Bill in
%       decimal form in terms of $100 of face value
%
%       AskYield - Nx1 bond equivalent yield.
%         
%     Settle - Nx1 vector of settlement dates implied by the maturity
%     dates and the number of days to maturity quote.
%
%   See also TR2BONDS.

%	Author(s): C. Bassignani, 11-12-97 
%   Copyright 1995-2002 The MathWorks, Inc. 
%	$Revision: 1.10 $   $Date: 2002/04/14 21:54:17 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check the number of arguments in
if (nargin ~= 1)
     error('Invalid number of input arguments; input TBillMatrix!')
end


%Check the dimensions of the TBillMatrix
InputSize = size(TBillMatrix);

if (InputSize(1, 2) < 5)
     error('TBill matrix if not of the correct size; should be Nx5!')
end
   
   
%Get all variables from matrix
TBillMaturity = TBillMatrix(:, 1);
TBillDaysMaturity = TBillMatrix(:, 2);
TBillBid = TBillMatrix(:, 3);
TBillAsked = TBillMatrix(:, 4);
TBillAskYield = TBillMatrix(:, 5);


%Get the length of each input column vector
InputVectorSize = size(TBillMaturity);
InputVectorLength = InputVectorSize(1, 1);


%Preallocate each intermediate output vector
TBondCouponRate = zeros(InputVectorSize);
TBondBidPrice = zeros(InputVectorSize);
TBondAskedPrice = zeros(InputVectorSize);
TBondAskYield = zeros(InputVectorSize);
TBondEquivSettle = zeros(InputVectorSize);

%Preallocate the output matrix
TBondMatrix = zeros(InputVectorLength, 5);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set face value equal to $100
Face = 100;

%Convert bid and ask bank discount yields to prices
% Bid and ask discounts are quoted on a skip-day settle basis.
% There are actually TBillDaysMaturity+1 days between settlement
% and maturity.

%Convert the bid bank discount yield to a bid price
TBondBidPrice(:) = (1 - (TBillBid .* (TBillDaysMaturity ./ 360))) .* Face;


%Convert the ask bank discount yield to an ask price
TBondAskedPrice(:) = (1 - (TBillAsked .* (TBillDaysMaturity ./ 360))) .* Face;

%Build the output matrix
TBondMatrix(:, 1) = TBondCouponRate;
TBondMatrix(:, 2) = TBillMaturity;
TBondMatrix(:, 3) = TBondBidPrice;
TBondMatrix(:, 4) = TBondAskedPrice;
TBondMatrix(:, 5) = TBillAskYield;

% Find the actual (Bond Equivalent) settlement date.
TBondEquivSettle(:) = TBillMaturity - TBillDaysMaturity - 1;


%end of TBILL2BOND function





