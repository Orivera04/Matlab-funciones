function ftbcflowflags()
%CFLOW FLAGS refers to the matrix of cash flow flags for a portfolio of bonds.
%Each row in the matrix contains the list of cash flows for a bond.
%Each element in a row identifies a particular cash flow of the bond.
%The locations in the matrix correspond to the dates given in CFlowDates.
%
%Flags are used to identify the type of each cash flow (i.e. it is a
%nominal coupon cash flow, a front or end partial or "stub" coupon, a
%maturity cash flow, etc). Possible values include: 
%
%  Flag = 0 - Refers to the accrued interest due on a bond at settlement.
%  Flag = 1 - Refers to an initial coupon cash flow amount that is smaller
%       than normal due to an initial "stub" coupon period. A stub period is
%       created when the issue date on a bond is specified such that the
%       period from the issue date to the first coupon date is shorter in 
%       length than a normal coupon period.
%  Flag = 2 - Refers to an initial coupon cash flow amount that is
%       larger than normal due to the fact that the first coupon period is
%       longer than normal.
%  Flag = 3 - Refers to a nominal coupon cash flow amount.
%  Flag = 4 - Refers to a normal maturity cash flow amount (i.e. face value
%       plus the nominal coupon amount)
%  Flag = 5 - Refers to an end "stub" cash flow on a coupon bond. This means
%       that the last coupon period for the bond is abnormally short, and 
%       that the actual maturity cash flow for that bond is smaller than 
%       normal.
%  Flag = 6 - Refers to a maturity cash flow for a coupon bond that is larger
%       than normal due to the fact that last coupon period is longer than 
%       normal.
%  Flag = 7 - Refers to a normal maturity cash flow on a coupon bond when 
%       the bond has less than one coupon period to maturity (i.e. it 
%       resembles a zero coupon bond). Note that the actual cash flow may 
%       be smaller than the stated coupon rate would indicate if the
%       period from issue to maturity is less than one year.
%  Flag = 8 - Refers to a smaller-than-normal maturity cash flow on a coupon
%       bond when the bond has less than one coupon period to maturity.
%  Flag = 9 - Refers to a larger-than-normal maturity cash flow on a coupon
%       bond when the bond has less than one coupon period to maturity.
%  Flag = 10 - Refers to the maturity cash flow on a zero coupon bond.

disp(' ');
disp('Type "help ftbcflowflags" for an explanation of CFLOW FLAGS');
disp(' ');

%Author(s): C. Bassignani, 07-30-98
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.7 $   $Date: 2002/04/14 21:48:11 $

