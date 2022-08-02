% Financial Toolbox
% Version 2.4 (R14) 05-May-2004
%
% Help and Documentation
%   Readme          - Release notes for the Financial Toolbox.
%   ftb             - Argument help headers.
%   calendar        - Contents of financial calendar functions
%
% Formatting Currency and Price.
%   cur2frac        - Decimal currency values to fractional values.
%   cur2str         - Bank formatted text.
%   dec2thirtytwo   - Decimal to thirty-second.
%   frac2cur        - Fractional currency values to decimal values.
%   thirtytwo2dec   - Thirty-second to decimal.
%   
% Charts.
%   bolling         - Bollinger Band chart.
%   candle          - Candlestick chart.
%   dateaxis        - Date axis labels.
%   highlow         - High, low, open, close chart.
%   movavg          - Leading and lagging moving averages chart.
%   pointfig        - Point and figure chart.
%   
% Present and Future Value.
%   fvdisc          - Future value of discounted security.
%   fvfix           - Future value with fixed periodic payments.
%   fvvar           - Future value of varying cash flow.
%   pvfix           - Present value with fixed periodic payments.
%   pvvar           - Present value of varying cash flow.%   
%
% Annuities.
%   annurate        - Periodic interest rate of annuity.
%   annuterm        - Number of periods to obtain value.
%   
% Accrued interest.
%   acrubond        - Accrued interest of security with periodic interest 
%                     payments.
%   acrudisc        - Accrued interest of security paying at maturity.
%   
% Prices.
%   bndprice        - Price of an SIA standard security.
%   prbond          - Price with regular periodic interest payments.
%   prmat           - Price with interest at maturity.
%   proddf          - Price with odd first period.
%   proddfl         - Price with odd first and last periods and settlement 
%                     in first period.
%   proddl          - Price with odd last period.
%   prtbill         - Price of treasury bill.
%   prdisc          - Price of discounted security.
%   
% Term Structure of Interest Rates.
%
%   bndspread       - Spread of bond over entire underlying curve.
%   disc2zero       - Zero curve given a discount curve.
%   fwd2zero        - Zero curve given a forward curve.
%   prbyzero        - Price bonds from a zero curve.
%   pyld2zero       - Zero curve given a par yield curve.
%   termfit         - Term structure fitting with the Spline Toolbox 
%                     (demonstration).
%   tbl2bond        - Format treasury bill data.
%   tr2bonds        - Format treasury bond data.
%   zbtprice        - Bootstrap zero rate curve from market bond prices.
%   zbtyield        - Bootstrap zero rate curve from market bond yields.
%   zero2disc       - Discount curve given a zero curve.
%   zero2fwd        - Forward curve given a zero curve.
%   zero2pyld       - Par yield curve given a zero curve.
%
% Yields.
%   bndyield        - Yield of an SIA standard security.
%   beytbill        - Bond equivalent yield for treasury bill.
%   discrate        - Discount rate of a security.
%   yldbond         - Yield with regular periodic interest payments.
%   yldmat          - Yield with interest at maturity.
%   yldoddf         - Yield with odd first period.
%   yldoddfl        - Yield with odd first and last periods and settlement 
%                     in first period.
%   yldoddl         - Yield with odd last period.
%   yldtbill        - Yield of treasury bill.
%   ylddisc         - Yield of discounted security.
%   
% Rates of return.
%   effrr           - Effective rate of return.
%   irr             - Internal rate of return.
%   mirr            - Modified internal rate of return.
%   nomrr           - Nominal rate of return.
%   taxedrr         - After-tax rate of return.
%   xirr            - Internal rate of return for nonperiodic cash flow.
%   
% Payment calculations.
%   payadv          - Periodic payment given number of advance payments.
%   payodd          - Payment of annuity with odd first period.
%   payper          - Periodic payment of loan or annuity.
%   payuni          - Uniform payment equal to varying cash flow.
%   
% Interest rate sensitivities.
%   bnddurp         - Duration of an SIA standard security from price. 
%   bnddury         - Duration of an SIA standard security from yield.
%   bndconvp        - Convexity of an SIA standard security from price.
%   bndconvy        - Convexity of an SIA standard security from yield.
%   bondconv        - Convexity.
%   bonddur         - Macaulay and modified durations.
%   cfconv          - Cash flow convexity and volatility.
%   cfdur           - Cash flow duration and modified duration.
%   
% Amortization and Depreciation.
%   amortize        - Amortization.
%   depfixdb        - Fixed declining-balance depreciation.
%   depgendb        - General declining-balance depreciation.
%   deprdv          - Remaining depreciable value.
%   depsoyd         - Sum of years' digits depreciation.
%   depstln         - Straight line depreciation.
%     
% Option valuation and sensitivity.
%   binprice        - Binomial put and call pricing.
%   blkprice        - Black's option pricing.
%   blsdelta        - Black-Scholes sensitivity to underlying price change.
%   blsgamma        - Black-Scholes sensitivity to underlying delta change.
%   blsimpv         - Black-Scholes implied volatility.
%   blslambd        - Black-Scholes elasticity.
%   blsprice        - Black-Scholes put and call values.
%   blsrho          - Black-Scholes sensitivity to interest rate change.
%   blstheta        - Black-Scholes sensitivity to time to maturity change.
%   blsvega         - Black-Scholes sensitivity to underlying price 
%                     volatility.
%   opprofit        - Option profit.
%   
% Volatility analysis (ARCH/GARCH)
%   ugarch          - Univariate ARCH/GARCH parameter estimation.
%   ugarchllf       - Log-likelihood function of univariate GARCH 
%                     parameters.
%   ugarchpred      - Forecast volatility based on a univariate GARCH 
%                     process.
%   ugarchsim       - Simulate a univariate GARCH process.
%
% Portfolio analysis.
%   abs2active      - Convert constraints from absolute to active format.
%   active2abs      - Convert constraints from active to absolute format.
%   cov2corr        - Convert covariance to standard deviation and 
%                     correlation.
%   corr2cov        - Convert standard deviation and correlation to 
%                     covariance.
%   ewstats         - Asset return and covariance estimation.
%   portsim         - Simulate multi-asset return time series.
%   ret2tick        - Asset return time series to price series.
%   tick2ret        - Asset price time series to return series.
%   frontcon        - Efficient frontier with basic constraints.
%   portalloc       - Capital allocation.
%   portopt         - Efficient frontier with arbitrary constraint set.
%   portcons        - Specify constraints on portfolio.
%   pcalims         - Portfolio asset allocation bounds.
%   pcglims         - Portfolio asset group allocation bounds.
%   pcgcomp         - Portfolio group to group composition bounds.
%   pcpval          - Portfolio total value.
%   portrand        - Randomized portfolio risks, returns and weights.
%   portstats       - Portfolio risk and expected rate of return.
%   portvrisk       - Portfolio value at risk.
%
% ============== Financial calendar functions (help calendar) ==============
%
% Current Time And Date.
%   today           - Current date.
%   
% Date and Time Components and Formats.
%   datedisp        - Display a matrix containing date number entries.
%   datefind        - Indices of date numbers in matrix.
%   day             - Day of month.
%   eomdate         - Last date of month.
%   hour            - Hour of date or time.
%   lweekdate       - Date of last occurrence of weekday in month.
%   minute          - Minute of date or time.
%   month           - Month of date.
%   months          - Number of whole months between dates.
%   m2xdate         - MATLAB date to Excel date.
%   nweekdate       - Date of specific occurrence of weekday in month.
%   second          - Second of date or time.
%   x2mdate         - Excel date to MATLAB date.
%   year            - Year of date.
%   yeardays        - Number of days in year.
%   
% Financial dates.
%   busdate         - Next or previous business day.
%   datemnth        - Date of day in future or past month.
%   datewrkdy       - Date of future or past workday.
%   days360         - Days between dates based on 360 day year (SIA).
%   days360e        - Days between dates based on 360 day year (Europe).
%   days360isda     - Days between dates based on 360 day year (ISDA).
%   days360psa      - Days between dates based on 360 day year (PSA).
%   days365         - Days between dates based on 365 day year.
%   daysdif         - Days between dates for any day count basis.
%   daysact         - Days between dates based on actual year.
%   fbusdate        - First business date of month.
%   holidays        - Holidays and non-trading days.
%   isbusday        - True for dates that are business days.
%   lbusdate        - Last business date of month.
%   thirdwednesday  - Third-Wednesday of the month.
%   wrkdydif        - Number of working days between dates.
%   yearfrac        - Fraction of  year between dates.
%   
% Coupon bond dates.
%   accrfrac        - Accrued interest coupon period fraction.
%   cfamounts       - Cash flow amounts for a security.
%   cfdates         - Cash flow dates for a security.
%   cftimes         - Cash flow time factors for a security.
%   cfport          - Portfolio form of cash flows.
%   cpncount        - Coupons payable between dates.
%   cpndaten        - Next coupon date after date.
%   cpndatenq       - Next quasi-coupon date after date.
%   cpndatep        - Previous coupon date before date.
%   cpndatepq       - Previous quasi-coupon date before date.
%   cpndaysn        - Number of days between date and next coupon date.
%   cpndaysp        - Number of days between date and previous coupon date.
%   cpnpersz        - Size in days of period containing date.
%
%  If the previous text just scrolled off your screen, try:
%      more on, help finance, more off

% Copyright 1995-2002 The MathWorks, Inc. 
% Generated from Contents.m_template revision 1.1.6.3   $Date: 2003/11/29 20:34:35 $

% Exposed private functions
%   checkrng        - argument checking used in finance and calendar 
%   checksiz        - argument checking used in finance and calendar 
%   checktyp        - argument checking used in finance and calendar 
%   checkbond       - for BDT demos in findemos
%   checkcreditcrv  - for BDT demos in findemos
%   checkstruct     - for BDT demos in findemos
%   checkvolcrv     - for BDT demos in findemos
%   checkzerocrv    - for BDT demos in findemos

% Exposed helper functions
%   portalloptpoint - for portalloc to fzero
%   portalltanpoint - for portalloc to fzero

% Private functions to toolbox/finance
