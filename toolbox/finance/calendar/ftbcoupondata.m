function ftbcoupondata()
%COUPON DATA refers to an Nx15 matrix containing various date parameters for
%a portfolio of bonds. Each row in the matrix corresponds to a specific
%bond in the portfolio. Each element columnwise in a row corresponds to
%a specific date parameter for a bond. Specified parameters include:
%
%     Column 1 - Number of coupon periods remaining until maturity.
%     Column 2 - Number of quasi coupon periods from settlement to the first
%                actual coupon date.
%     Column 3 - Number of quasi coupon periods from the last actual coupon
%                date to the maturity date.
%     Column 4 - Quasi coupon date prior to issue date; if no issue date is
%                specified, issue date is assumed to be the settlement date.
%     Column 5 - Issue date.
%     Column 6 - Quasi coupon date following the issue date.
%     Column 7 - Coupon date prior to the settlement date.
%     Column 8 - Quasi coupon date prior to settlement. (Note: This is not
%                always the actual previous coupon date. It can be different
%                in cases where the first coupon date is explicitly specified.)
%     Column 9 - Settlement date.
%     Column 10 - Quasi coupon date following the settlement date. (Note:
%                 This is not always the next coupon date. It can be different
%                 in cases where the first coupon date is explicitly specified
%                 and follows the settlement date.)
%     Column 11 - Coupon date immediately following the settlement date.
%     Column 12 - Last coupon date prior to maturity.
%     Column 13 - Quasi coupon date just prior to maturity. (Note: This date
%                 may differ from the last coupon date, depending on whether
%                 the last coupon date is specified.)
%     Column 14 - Maturity date.
%     Column 15 - Quasi coupon date immediately following the maturity date.

disp(' ');
disp('Type "help ftbcoupondata" for an explanation of COUPON DATA');
disp(' ');

%Author(s): C. Bassignani, 06-16-98
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.8 $   $Date: 2002/04/14 21:48:17 $
