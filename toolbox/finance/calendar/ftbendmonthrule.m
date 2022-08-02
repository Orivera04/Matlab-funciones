function ftbendmonthrule()
%
%END MONTH RULE refers to application of the "end of the month rule" in
%determining a bond's coupon structure. When the rule is in effect, a security
%that pays a coupon on the last actual day of a month will always pay coupons
%on the last day of the month. This means, for example, that a semiannual
%bond which pays a coupon on February 28th in non-leap years will pay coupons
%on August 31st in all years and on August 29th in leap years. Possible
%values are:
%
%     1) EndMonthRule = 1 (default) - rule is in effect for the
%          bond, meaning that a security that pays coupon interest
%          on the last day of the month will always make payment on
%          the last day of the month.
%
%     2) EndMonthRule = 0 - rule is NOT in effect for the bond.


disp(' ');
disp('Type "help ftbendmonthrule" for an explanation of END MONTH RULE');
disp(' ');

%   Author(s): C. Bassignani, 03-11-98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.7 $   $Date: 2002/04/14 21:48:23 $

