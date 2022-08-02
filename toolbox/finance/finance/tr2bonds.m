function [Bonds, Prices, Yields] = tr2bonds(TreasuryMatrix, Settle)
%TR2BONDS Bonds Matrix, Prices Vector, and Yields Vector Given a Standard
%   Treasury Matrix.
%
%   [Bonds, Prices, Yields] = tr2bonds(TreasuryMatrix, Settle)
%
%   Summary: 
%     This function creates a sorted Bonds matrix, Prices vector, and Yields
%     vector of the form required by the ZBTPRICE and ZBTYIELD bootstrapping
%     functions given a standard matrix of Treasury note and bond data.
%
%   Inputs: 
%     TreasuryMatrix - Nx5 matrix of U.S. Treasury Bond data comprised
%     of the following parameters:
%       CouponRate - Nx1 column vector of values in decimal form
%         representing the coupon rates for each bond in the portfolio
%       Maturity - Nx1 column vector of values representing the maturity
%         dates in serial date number form for each bond in the portfolio
%       Bid - Nx1 column vector of bid prices in integer-decimal form for
%         each for each bond in the portfolio
%       Asked - Nx1 column vector of asked prices in integer-decimal form
%         for each bond in the portfolio
%       AskYield - Nx1 column vector of values in decimal form representing
%         the quoted ask yield for each bond in the portfolio
%
%     Settle - (optional) Date string or serial date number of the
%     settlement date for the analysis.
%
%   Outputs: 
%     Bonds - the portfolio of coupon bonds from which the zero curve will
%       be derived; specifically, an NxM matrix of bond parameters where each
%       row of the matrix corresponds to an individual bond and each column
%       corresponds to a particular parameter; the  required columns
%       (parameters) for this matrix are:
%     Maturity - (Column 1) the maturity for each bond in the portfolio in
%       serial date number form
%     CouponRate - (Column 2) the coupon rate for each bond in the portfolio
%       in decimal form
%     Optional columns (parameters) are:
%       Face - (Column 3) face value of each bond in the portfolio; default
%         is $100
%       Period - (Column 4) the number of coupon payments per year in
%         integer form; possible values are 1, 2 (default), 3, 4, 6 and 12
%       Basis - (Column 5) values specifying the basis for each bond in the
%         portfolio; possible values include:
%         1) Basis = 0 - actual/actual(default)
%         2) Basis = 1 - 30/360
%         3) Basis = 2 - actual/360
%         4) Basis = 3 - actual/365
%       EndMonthRule - (Column 6) value specifying whether or no the "end
%         of month rule" is in effect for each bond contained in the
%         portfolio possible values include:
%         1) EndMonthRule = 1 (default) - rule is in effect for the bond
%            (meaning that a security which pays coupon interest on
%            the last day of the month will always make payment on the
%            ast day of the month)
%         2) EndMonthRule = 0 - rule is NOT in effect for the bond
%       Prices -  Nx1 column vector containing price values for each bond
%         contained in the portfolio represented by the Bonds matrix
%       Yields - Nx1 column vector containing yield values for each bond
%         contained in the portfolio represented by the Bonds matrix.
%         If Settle is passed in, Yields will be computed as a semi-annual
%         yield to maturity.  If Settle is not passed in, the quoted input
%         yields will be used.
%
%	 See also TBL2BOND, BNDYIELD.

%	Author(s): C. Bassignani, 11-17-97 
%   Copyright 1995-2002 The MathWorks, Inc. 
%	$Revision: 1.9 $   $Date: 2002/04/14 21:54:23 $ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Get the size of the inputs
InputSize = size(TreasuryMatrix);
InputLength = InputSize(1, 1);
OutputVectorSize = [InputLength, 1];

%Preallocate the output matrix and vectors

%Preallocate the Bonds matrix
Bonds = zeros(InputLength, 6);


%Preallocate the Prices and Yields vectors
Prices = zeros(InputLength, 1);
Yields = zeros(InputLength, 1);


%Get all intermediate variables from the input matrix
TreasuryCouponRate = TreasuryMatrix(:, 1);
TreasuryMaturity = TreasuryMatrix(:, 2);
TreasuryBid = TreasuryMatrix(:, 3);
TreasuryAsked = TreasuryMatrix(:, 4);
TreasuryAskYield = TreasuryMatrix(:, 5);

if (nargin<2)
  Settle = [];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Build the output Bonds matrix
[SortedTreasuryMaturity, SortIndex] = sort(TreasuryMaturity);
Bonds(:, 1) = SortedTreasuryMaturity;
Bonds(:, 2) = TreasuryCouponRate(SortIndex);
Bonds(:, 3) = 100 * ones(OutputVectorSize);
Bonds(:, 4) = 2 * ones(OutputVectorSize);
Bonds(:, 5) = zeros(OutputVectorSize);
Bonds(:, 6) = ones(OutputVectorSize);

% Set the periodicity of zero coupon bonds to zero
Bonds( Bonds(:,2)==0 , 4 ) = 0;

%Build the ouput vectors
Prices = TreasuryAsked(SortIndex);

if ( nargout>=3 )
  % Return Yields
  
  if isempty(Settle)
    % Return the input yields 
    Yields = TreasuryAskYield(SortIndex);
  else
    % Compute the yield to maturity consistent with the price
    % bndyield(Price, CouponRate, Settle, Maturity, Period)
    Yields = bndyield(Prices, Bonds(:,2), Settle, Bonds(:,1), Bonds(:,4));
  end

end

%end of TREASURY2BONDS function


