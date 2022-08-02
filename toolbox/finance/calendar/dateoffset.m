function [CpnDay, CpnMonth, CpnYear] = dateoffset(RefDay, RefMonth, RefYear, monthOffset, Rule)
%DATEOFFSET Date offset from a reference date by a number of months.
%   Compute the date (in the past or future) offset from a reference date by an
%   integer number of months. Negative month offsets correspond to dates in the
%   past; positive month offsets correspond to dates in the future.
%
%   [CpnDay, CpnMonth, CpnYear] = dateoffset(RefDay , RefMonth , RefYear , ...
%                                            MonthOffset)
%
%   [CpnDay, CpnMonth, CpnYear] = dateoffset(RefDay , RefMonth , RefYear , ...
%                                            MonthOffset , Rule)
%
%   Inputs: 
%     RefDay - Day of the month of the specified reference date.
%     RefMonth - Month of the specified reference date.
%     RefYear - Year of the specified reference date.
%
%   MonthOffset - The integer number of months, with respect to the reference
%     date, to move forward or backward in time to compute the output date. 
%     Negative month offsets correspond to dates in the past; positive month
%     offsets correspond to dates in the future.
%
%   Optional Input:
%     Rule - Integer rule indicator specifying the day count basis and the 
%     end-of-month convention used when determining past or future dates. 
%     The rule mapping is as follows:
%                                         End of Month Rule
%     Rule                    Basis          in Effect?
%     ----                -------------   -----------------
%       0 (default) -->   actual/actual         Yes
%       1           -->       30/360            Yes
%       2           -->   actual/360            Yes
%       3           -->   actual/365            Yes
%       4           -->   actual/actual          No
%       5           -->       30/360             No
%       6           -->   actual/360             No
%       7           -->   actual/365             No
%
%     When the end-of-month convention is in effect (rule values 0,1,2,3), it 
%     means that if you are beginning on the last day of a month, and the 
%     month has 30 or fewer days, you will land on the last actual day of the
%     future or past month regardless of whether that month has 28, 29, 30, or
%     31 days.
%
%   Outputs: 
%     CpnDay - Day of the past or future month relative to the reference date.
%     CpnMonth - Past or future month relative to the reference date.
%     CpnYear - Year of the past or future month relative to the reference date.
%
%   See also DAYS360, DAYS365, DAYSACT, DAYSDIF, WRKDYDIF.

% Copyright 1995-2002 The MathWorks, Inc.
% $Revision: 1.7 $   $Date: 2002/04/14 21:50:33 $

%
% Ensure enough input arguments have been specified.
%

if nargin < 4
   error(' 4 Inputs Required (RefDay, RefMonth, RefYear, MonthOffset).');
end

%
% Set default for optional input argument: Actual/actual 
% day-count basis with end-of-month convention in effect.
%

if (nargin < 5) | isempty(Rule)
   Rule  =  0;
end

%
% Perform row, column, or scalar expansion as necessary, and 
% pre-allocate the outputs with NaN's as a default.
%

[RefDay   , RefMonth   , RefYear   , monthOffset   , Rule   ] = finargsz('scalar', ...
 RefDay(:), RefMonth(:), RefYear(:), monthOffset(:), Rule(:));

%
% Determine which elements are valid (i.e., non-NaN's, 
% non-Inf's, etc.) for all required input arguments.
%

validIndices = isfinite(sum([RefDay(:) RefMonth(:) RefYear(:) monthOffset(:)] ,2));

RefDay     (~validIndices) =  NaN;
RefMonth   (~validIndices) =  NaN;
RefYear    (~validIndices) =  NaN;
monthOffset(~validIndices) =  NaN;

%
% Set all invalid (i.e., NaN's, Inf's, etc.) rule indicators to the default.
%

Rule(~isfinite(Rule))  =  0;

%
% Find the past or future month relative to the reference date.
%

CpnMonth  =  rem(RefMonth + monthOffset - 1 , 12);

% 
% Set output month number (must be between 1 and 12).
%

CpnMonth  =  rem(CpnMonth + 12 , 12) + 1;

%
% Increment year if necessary
%

CpnYear  =  RefYear + floor((RefMonth + monthOffset - 1)/12);

%
% Set the default day. 
%

CpnDay  =  RefDay;

%
% Find all cases for which the reference day is on or after the 28th.
% These late-in-the-month cases are handled as a table lookup. The
% lookup table is organized as follows:
%
% CpnDay  =  DayTable(CpnMonth , RefDay , RefMonth , Rule)
%                        13    x    4   x    13    x   8
%

LookupIndex = (CpnDay >= 28);

if any(LookupIndex)

   persistent DayTable

   if isempty(DayTable)
%
%     Load the lookup table if not already in memory.
%
      DayTable = daytablegen;

   end
%
%  Set the reference month indices for the table lookup.
%
   LookRefMonth              = RefMonth;
   LookCpnMonth              = CpnMonth;

   LookRefMonth(LookupIndex) = RefMonth(LookupIndex);
   LookCpnMonth(LookupIndex) = CpnMonth(LookupIndex);

%
%  Find if RefMonth or CpnMonth is a February of a leap year.
%

   RefFebLeapYear = (RefMonth == 2) & ((rem(RefYear,4) == 0 & rem(RefYear,100) ~= 0) | rem(RefYear,400) == 0);
   CpnFebLeapYear = (CpnMonth == 2) & ((rem(CpnYear,4) == 0 & rem(CpnYear,100) ~= 0) | rem(CpnYear,400) == 0);

   LookRefMonth(RefFebLeapYear)  =  13;
   LookCpnMonth(CpnFebLeapYear)  =  13;

%
%  Create indices for day and basis/end-of-month rules.
%

   LookRefDay = RefDay;
   LookRule   = Rule;

   LookRefDay(LookupIndex) = RefDay(LookupIndex) - 27;
   LookRule  (LookupIndex) =   Rule(LookupIndex) +  1;

%
%  Convert individual indices for each dimension into a single table lookup index.
%

   DayTableIndex  =  LookCpnMonth  + 13*(LookRefDay - 1);
   DayTableIndex  =  DayTableIndex + 13*4*(LookRefMonth - 1) + 13*4*13*(LookRule - 1);

   DayTableIndex  =  DayTableIndex(LookupIndex);

%
%  Perform the table lookup.
%
   CpnDay(LookupIndex) = DayTable(DayTableIndex);

end


%---------------------------------------------------------------------------------
%---------------------------------------------------------------------------------
function daytable = daytablegen()
%DAYTABLEGEN Generate payment dates lookup table for late-month reference dates.
%   Whenever the day of the month associated with the reference date occurs 
%   late in a month (i.e., on the 28th, 29th, 30th, or 31st), the coupon payment 
%   date will be handled as a table lookup. The lookup table is organized as 
%   follows:
%
%   DayTable(CpnMonth , RefDay , RefMonth , Rule)
%               13    x    4   x    13    x   8
%   
%   The month indices (i.e., CpnMonth & RefMonth) are formatted as follows:
%
%                    Index    Month
%                    -----    -----
%                      1       Jan
%                      2       Feb (non-leap year)
%                      3       Mar
%                      4       Apr
%                      5       May
%                      6       Jun
%                      7       Jul
%                      8       Aug
%                      9       Sep
%                     10       Oct
%                     11       Nov
%                     12       Dec
%                     13       Feb (leap year)
%
%   The reference day (i.e., RefDay) is formatted as follows:
%
%                    Index    Day
%                    -----    ----
%                      1       28
%                      2       29
%                      3       30
%                      4       31
%
%   The rule indicator (i.e., Rule) is formatted as follows:
%
%                                                   End of Month Rule
%       Index   Rule                   Basis           in Effect?
%       -----   ----                -------------   -----------------
%         1       0 (default) -->   actual/actual         Yes
%         2       1           -->       30/360            Yes
%         3       2           -->   actual/360            Yes
%         4       3           -->   actual/365            Yes
%         5       4           -->   actual/actual          No
%         6       5           -->       30/360             No
%         7       6           -->   actual/360             No
%         8       7           -->   actual/365             No
%

rule = 1;     % Act/Act, EOM On.
smonth = 1;   % January
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 2;   % February, non-leap year
daytable(:, :, smonth, rule) = [ 31 NaN NaN NaN; 
                                 28 NaN NaN NaN; 
                                 31 NaN NaN NaN; 
                                 30 NaN NaN NaN; 
                                 31 NaN NaN NaN; 
                                 30 NaN NaN NaN; 
                                 31 NaN NaN NaN; 
                                 31 NaN NaN NaN; 
                                 30 NaN NaN NaN; 
                                 31 NaN NaN NaN; 
                                 30 NaN NaN NaN; 
                                 31 NaN NaN NaN; 
                                 29 NaN NaN NaN ];
smonth = 3;   % March
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 4;   % April
daytable(:, :, smonth, rule) = [ 28  29  31 NaN; 
                                 28  28  28 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  29 NaN ];
smonth = 5;   % May
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 6;   % June
daytable(:, :, smonth, rule) = [ 28  29  31 NaN; 
                                 28  28  28 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  29 NaN ];
smonth = 7;   % July
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 8;   % August
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 9;   % September
daytable(:, :, smonth, rule) = [ 28  29  31 NaN; 
                                 28  28  28 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  29 NaN ];
smonth = 10;   % October
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 11;   % November
daytable(:, :, smonth, rule) = [ 28  29  31 NaN; 
                                 28  28  28 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  30 NaN; 
                                 28  29  31 NaN; 
                                 28  29  29 NaN ];
smonth = 12;   % December
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 13;   % February, leap year
daytable(:, :, smonth, rule) = [ 28  31 NaN NaN; 
                                 28  28 NaN NaN; 
                                 28  31 NaN NaN; 
                                 28  30 NaN NaN; 
                                 28  31 NaN NaN; 
                                 28  30 NaN NaN; 
                                 28  31 NaN NaN; 
                                 28  31 NaN NaN; 
                                 28  30 NaN NaN; 
                                 28  31 NaN NaN; 
                                 28  30 NaN NaN; 
                                 28  31 NaN NaN; 
                                 28  29 NaN NaN ];

%--------------------------------
rule = 2;     %  30/360, EOM On.
daytable(:, :, :, rule) = daytable(:, :, :, 1);

%--------------------------------
rule = 3;     %  Actual/360, EOM On.
daytable(:, :, :, rule) = daytable(:, :, :, 1);

%--------------------------------
rule = 4;     %  Actual/365, EOM On.
daytable(:, :, :, rule) = daytable(:, :, :, 1);

%--------------------------------
rule = 5;     % Act/Act, EOM Off.
smonth = 1;   % January
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 2;   % February, non-leap year
daytable(:, :, smonth, rule) = [ 28 NaN NaN NaN; 
                                 28 NaN NaN NaN; 
                                 28 NaN NaN NaN; 
                                 28 NaN NaN NaN; 
                                 28 NaN NaN NaN; 
                                 28 NaN NaN NaN; 
                                 28 NaN NaN NaN; 
                                 28 NaN NaN NaN; 
                                 28 NaN NaN NaN; 
                                 28 NaN NaN NaN; 
                                 28 NaN NaN NaN; 
                                 28 NaN NaN NaN; 
                                 28 NaN NaN NaN ];
smonth = 3;   % March
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 4;   % April
daytable(:, :, smonth, rule) = [ 28  29  30 NaN; 
                                 28  28  28 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  29 NaN ];
smonth = 5;   % May
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 6;   % June
daytable(:, :, smonth, rule) = [ 28  29  30 NaN; 
                                 28  28  28 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  29 NaN ];
smonth = 7;   % July
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 8;   % August
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 9;   % September
daytable(:, :, smonth, rule) = [ 28  29  30 NaN; 
                                 28  28  28 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  29 NaN ];
smonth = 10;   % October
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 11;   % November
daytable(:, :, smonth, rule) = [ 28  29  30 NaN; 
                                 28  28  28 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  30 NaN; 
                                 28  29  29 NaN ];
smonth = 12;   % December
daytable(:, :, smonth, rule) = [ 28  29  30  31; 
                                 28  28  28  28; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  30  30; 
                                 28  29  30  31; 
                                 28  29  29  29 ];
smonth = 13;   % February, leap year
daytable(:, :, smonth, rule) = [ 28  29 NaN NaN; 
                                 28  28 NaN NaN; 
                                 28  29 NaN NaN; 
                                 28  29 NaN NaN; 
                                 28  29 NaN NaN; 
                                 28  29 NaN NaN; 
                                 28  29 NaN NaN; 
                                 28  29 NaN NaN; 
                                 28  29 NaN NaN; 
                                 28  29 NaN NaN; 
                                 28  29 NaN NaN; 
                                 28  29 NaN NaN; 
                                 28  29 NaN NaN ];

%--------------------------------
rule = 6;     %  30/360, EOM Off.
daytable(:, :, :, rule) = daytable(:, :, :, 5);

%--------------------------------
rule = 7;     %  Actual/360, EOM Off.
daytable(:, :, :, rule) = daytable(:, :, :, 5);

%--------------------------------
rule = 8;     %  Actual/365, EOM Off.
daytable(:, :, :, rule) = daytable(:, :, :, 5);

return


