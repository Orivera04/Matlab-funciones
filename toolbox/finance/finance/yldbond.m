function Yield = yldbond(Settle, Maturity, Face, Price, CouponRate, Period,...
     Basis, MaxIterations, EndMonthRule) 
%YLDBOND Yield to Maturity for a Bond. 
%
%   Yield = yldbond(Settle, Maturity, Face, Price, CouponRate, Period,...
%   Basis, MaxIterations, EndMonthRule)
%
%   Summary: 
%     Given standard bond parameters this function determines the yield
%     to maturity for both coupon and zero-coupon bonds using a Newton-
%     Ralphson iterative method.
%
%   Inputs: 
%     Settle - (required) Nx1 or 1xN vector of values in serial date
%     number form representing the settlement date for the bond(s)
%
%     Maturity - (required) Nx1 or 1xN vector of values in serial date
%     number form representing the maturity date for the bond(s)
%
%     Face - (required) Nx1 or 1xN vector of values for the face value of
%     the bond(s)
%
%     Price - (required) Nx1 or 1xN vector of values for the price of the
%     bond(s)
%
%     CouponRate - (optional) Nx1 or 1xN vector of values for the coupon
%     rate of the bond(s).  The default is zero
%
%     Period - (optional) Nx1 or 1xN vector of values representing the
%     frequency of coupon payments for the bond(s); possible values include:
%       Period = 0 - zero coupon bond
%       Period = 1 - annual coupon payments
%       Period = 2 - semi-annual coupon payments (default)
%       Period = 3 - three coupon payments per year
%       Period = 4 - quarterly coupon payments
%       Period = 6 - bi-monthly coupon payments
%       Period = 12 - monthly coupon payments
%
%     Basis - Nx1 or 1xN vector or scalar value specifying the basis for
%     the bond(s); possible values include:
%     1) Basis = 0 - actual/actual(default)
%     2) Basis = 1 - 30/360
%     3) Basis = 2 - actual/360
%     4) Basis = 3 - actual/365
%
%     MaxIterations - scalar value representing the number of iterations
%     to be used in Newton's method when deriving the yield to
%     maturity for the bond(s); the default is 5 (Note: MaxIterations
%     may also be passed as an empty matrix in cases where the user
%     wants to use the default value but also wants to pass the end
%     of month rule flag to the function.)
%
%     EndMonthRule - Nx1 or 1xN vector or scalar value specifying whether
%     or not the "end of month rule" is in effect for the bond(s);
%     possible values include:
%     1) EndMonthRule = 1 (default) - rule is in effect for the bond(s)
%        (meaning that a security that pays coupon 
%        interest on the last day of the month will always
%        make payment on the last day of the month)
%     2) EndMonthRule = 0 - rule is NOT in effect for the bond(s)
% 
%   Example: 
%     Settle = '01-Jan-1960';
%     Maturity = '01-Jan-1990';
%     Face = 1000;
%     Price = 1276.76;
%     CouponRate = 0.08;
%     Period = 2;
%     Basis = 0;
%     EndMonthRule = 1;
%       
%     Yield = yldbond(Settle, Maturity, Face, Price, ...
%          CouponRate, Period, Basis)
%       
%     returns:
%
%     Yield = 0.0599
%
%   See also PRBOND, YLDDISC, YLDMAT.

%	Author: C. Garvin, J. Akao, and C. Bassignani, 11/25/97 
%   Copyright 1995-2002 The MathWorks, Inc. 
%	$Revision: 1.14 $ $Date: 2002/04/14 21:56:17 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check the number of arguments passed in and set all defaults

if (nargin < 4)
     error('Please enter at least Settle, Maturity, Face, and Price!')
end

if (nargin < 9)
     EndMonthRule = 1;
end

if (nargin < 8) 
     MaxIterations = 50; 
end

if (nargin < 7) 
     Basis = 0; 
end

if (nargin < 6) 
     Period = 2; 
end

if (nargin < 5);
     CouponRate = 0;
end


%Convert dates to serial date numbers of if necessary
if (isstr(Settle))
     Settle = datenum(Settle); 
end

if (isstr(Maturity))
     Maturity = datenum(Maturity);
end


%Make sure settlement and maturity dates are valid
SettLMat = find(Settle > Maturity);
if (~isempty(SettLMat))
     error('Settlement date must be less than or equal to maturity date!')
     return
end


%Parse frequency argument
if (any(Period ~= 0 & Period ~= 1 & Period ~= 2 & Period ~= 3 & Period ~= 4 & ...
          Period ~=6 & Period ~= 12 & Period ~= 365));
     error('Invalid period specified!')
end


%Parse basis argument
if (any(Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3));
     error('Invalid basis specified!')
end


%Parse the end of month rule
if (any(EndMonthRule ~= 0 & EndMonthRule ~= 1));
     error('Invalid EndMonthRule flag specified!')
end


%Parse max iterations and make sure that is a scalar value
if (isempty(MaxIterations))
     MaxIterations = 50;
end

if (length(MaxIterations(:)) > 1)
     error('MaxIterations must be a scalar value!')
end


%Do scalar expansion on input arguments where necessary

%Get the size of all other input arguments; scale up any scalars
sz = [size(Settle); size(Maturity); size(Face); size(Price); size(CouponRate); ...
          size(Period); size(Basis); size(EndMonthRule)]; 

if (length(Settle) == 1)
     Settle = Settle * ones(max(sz(:,1)), max(sz(:,2))); 
end 

if (length(Maturity) == 1)
     Maturity = Maturity * ones(max(sz(:,1)), max(sz(:,2))); 
end 

if (length(Face) == 1)
     Face = Face * ones(max(sz(:,1)), max(sz(:,2))); 
end 

if (length(Price) == 1)
     Price = Price * ones(max(sz(:,1)), max(sz(:,2))); 
end 

if (length(CouponRate) == 1)
     CouponRate = CouponRate * ones(max(sz(:,1)), max(sz(:,2))); 
end 

if (length(Period) == 1)
     Period = Period * ones(max(sz(:,1)), max(sz(:,2))); 
end 

if (length(Basis) == 1)
     Basis = Basis * ones(max(sz(:,1)), max(sz(:,2))); 
end

if (length(EndMonthRule) == 1)
     EndMonthRule = EndMonthRule * ones(max(sz(:,1)), max(sz(:,2)));
end

if (length(MaxIterations) == 1)
     MaxIterations = MaxIterations * ones(max(sz(:,1)), max(sz(:,2)));
end


%Make sure all input arguments are of the same size and shape
if (checksiz([size(Settle); size(Maturity); size(Face); size(Price); size(CouponRate);...
               size(Period); size(Basis); size(EndMonthRule); size(MaxIterations)],...
          mfilename))
     return
end

Yield = bndyield(Price,CouponRate,Settle,Maturity,Period,Basis,EndMonthRule,[],[],[],[],Face);

