% Financial Toolbox calendar functions.
%
% Current Time And Date.
%   today       - Current date.
%   
% Date and Time Components and Formats.
%   datedisp    - Display a matrix containing date number entries.
%   datefind    - Indices of date numbers in matrix.
%   day         - Day of month.
%   eomdate     - Last date of month.
%   hour        - Hour of date or time.
%   lweekdate   - Date of last occurrence of weekday in month.
%   minute      - Minute of date or time.
%   month       - Month of date.
%   months      - Number of whole months between dates.
%   m2xdate     - MATLAB date to Excel date.
%   nweekdate   - Date of specific occurrence of weekday in month.
%   second      - Second of date or time.
%   x2mdate     - Excel date to MATLAB date.
%   year        - Year of date.
%   yeardays    - Number of days in year.
%   
% Financial dates.
%   busdate     - Next or previous business day.
%   datemnth    - Date of day in future or past month.
%   datewrkdy   - Date of future or past workday.
%   days360     - Days between dates based on 360 day year.
%   days365     - Days between dates based on 365 day year.
%   daysdif     - Days between dates for any day count basis.
%   daysact     - Days between dates based on actual year.
%   fbusdate    - First business date of month.
%   holidays    - Holidays and non-trading days.
%   isbusday    - True for dates that are business days.
%   lbusdate    - Last business date of month.
%   wrkdydif    - Number of working days between dates.
%   yearfrac    - Fraction of  year between dates.
%   
% Coupon bond dates.
%   accrfrac    - Accrued interest coupon period fraction.
%   cfamounts   - Cash flow amounts for a security.
%   cfdates     - Cash flow dates for a security.
%   cftimes     - Cash flow time factors for a security.
%   cfport      - Portfolio form of cash flows.
%   cpncount    - Coupons payable between dates.
%   cpndaten    - Next coupon date after date.
%   cpndatenq   - Next quasi-coupon date after date.
%   cpndatep    - Previous coupon date before date.
%   cpndatepq   - Previous quasi-coupon date before date.
%   cpndaysn    - Number of days between date and next coupon date.
%   cpndaysp    - Number of days between date and previous coupon date.
%   cpnpersz    - Size in days of period containing date.
%

% $Revision: 1.15 $   $Date: 2002/04/14 21:49:59 $
% Copyright 1995-2002 The MathWorks, Inc. 

% Exposed private functions
%   chkbonddateparams - used for cfprice and cfyield in finance 

% Private functions
%   scaleupvarg
