function ftblastcoupondate
%
%LAST COUPON DATE refers to the last coupon date of a bond prior to the
%MATURITY date.  The last coupon period before maturity may be an
%irregular length, either short or long.  In the absence of a specified
%FIRST COUPON DATE, the bond will pay other coupons at regular intervals
%from LAST COUPON DATE, plus a coupon at MATURITY date.  If neither FIRST
%COUPON DATE nor LAST COUPON DATE are specified, coupons fall at regular
%intervals from the MATURITY date.
%
%When both FIRST COUPON DATE and LAST COUPON DATE are specified, the
%two dates must be a whole number of regular coupon periods apart.

disp(' ');
disp('Type "help ftblastcoupondate" for an explanation of LAST COUPON DATE');
disp(' ');

%Author(s): C. Bassignani, 03-11-98
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.6 $   $Date: 2002/04/14 21:48:29 $
