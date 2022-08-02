function bdates = busdays(sdate, edate, bdmode, holvec)
%BUSDAYS generates a vector of business days in serial date format.
%
%   BDATES = BUSDAYS(SDATE, EDATE, BDMODE) generates a vector of business 
%   days, BDATES, in serial date format between the start date, SDATE, 
%   and the last business date of the frequency, BDMODE. If the ending
%   date, EDATE, is not the last business day of the specified frequency,
%   the next business date in line will be returned.
%   
%   For example:
%      vec = datestr(busdays('1/2/01','1/9/01','weekly'))
%      vec =
%      05-Jan-2001
%      12-Jan-2001
%
%      The end-of-week is considered to be a Friday. Between
%      1/2/01 (Monday) and 1/9/01 (Tuesday) there is only one
%      end-of-week day, 1/5/01 (Friday). Since 1/09/01 is part 
%      of following week, the following Friday (1/12/01) is 
%      also reported.
%
%   In additon only US holidays are taken into account.  If BDMODE is not 
%   supplied, a 'daily' vector is generated. 
%   
%   BDATES = BUSDAYS(SDATE, EDATE, BDMODE, HOLVEC) is similar to the above
%   with the exception of the holidays.  You can supply your own holiday
%   vectors, HOLVEC, which will be used to generate business days.  HOLVEC
%   can either be in serial date format or date string format.  If you use
%   this syntax, you need to supply the frequency, BDMODE.
%
%   Inputs:
%      SDATE  = Starting Date, in string or serial date format
%      EDATE  = Ending date, in string or serial date format
%      BDMODE = frequency of business days; valid ones are (the
%               strings must be enclosed in single quotes):
%
%                 DAILY,      Daily,      daily,      D, d, 1
%                 WEEKLY,     Weekly,     weekly,     W, w, 2
%                 MONTHLY,    Monthly,    monthly,    M, m, 3
%                 QUARTERLY,  Quarterly,  quarterly,  Q, q, 4
%                 SEMIANNUAL, Semiannual, semiannual, S, s, 5
%                 ANNUAL,     Annual,     annual,     A, a, 6
%
%      HOLVEC = holiday dates vector, in string or serial date format
%
%   Output:
%      BDATES = column vector of business dates, in serial date format
%
%   Note: If you desire a weekday vector without the holidays, set the
%         HOLVEC input to '' (empty string) or [] (empty vector/matrix).

%   Author: P. N. Secakusuma, 03-03-99
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.12.2.2 $   $Date: 2004/04/06 01:09:20 $

% Check inputs
if nargin < 2 | nargin > 4
    error('Ftseries:ftseries_busdays:InvalidNumInputs', 'Invalid number of inputs.');
end
if nargin ~= 4
    holvec = holidays;
end

% If BDMODE is not specified, assume Daily frequency
if nargin==2
    bdmode = 1;
end

% In the date inputs are in string format, 
% change them to serial date format
if ischar(sdate)
    sdate = datenum(sdate);
end
if ischar(edate)
    edate = datenum(edate);
end

% Generate a vector of all possible dates between the
% start and end dates
dtvec = sdate:edate;

% Generate a vector of numbers representing the days i.e.
% 0:Sunday, 1:Monday, ..., 6:Saturday
dyvec = mod(dtvec+5, 7);   % Day vector

% Return only the days corresponding to the frequency asked
switch lower(bdmode)
case {'daily', 'd', 1}  % Daily; return all weekdays
    bdates = dtvec(find(dyvec ~= 0 & dyvec ~=6));
case {'weekly', 'w', 2}  % Weekly; return only Fridays
    dtvec  = sdate:edate+(5-dyvec(end));
    dyvec = mod(dtvec+5, 7);
    bdates = dtvec(find(dyvec == 5));
case {'monthly', 'm', 3}   % Monthly; return only end of month days
    [byear, bmonth, bday] = datevec(dtvec);
    ubyrmon = unique([byear' bmonth'], 'rows');
    bdates = eomdate(ubyrmon(:, 1), ubyrmon(:, 2));
case {'quarterly', 'q', 4}   % Quarterly; return only end of quarter days
    [byear, bmonth, bday] = datevec(dtvec);
    ubyrqtr = unique([byear' ceil(bmonth'/3)], 'rows');
    bdates = eomdate(ubyrqtr(:, 1), ubyrqtr(:, 2).*3);
case {'semiannual', 's', 5}   % Semiannual; return only end of semiannual period days
    [byear, bmonth, bday] = datevec(dtvec);
    ubyrsemi = unique([byear' ceil(bmonth'/6)], 'rows');
    bdates = eomdate(ubyrsemi(:, 1), ubyrsemi(:, 2).*6);
case {'annual', 'a', 6}   % Annual; return only end of year days
    [byear, bmonth, bday] = datevec(dtvec);
    ubyear = unique(byear');
    bdates = eomdate(ubyear, 12);
otherwise
    error('Ftseries:_busdays:InvalidFREQ', ...
        'Invalid frequency.');
end

% Check to see if at least one date is valid.  If all of them are
% invalid, don't do anything else and return an empty matrix.
if isempty(bdates)
    bdates = [];
    return
end

% Make sure that the dates are business dates
notbday = ~isbusday(bdates, holvec);
if any(notbday)
    switch lower(bdmode)
    case {'daily', 'd', 1}   % Daily; drop the non-business days
        bdates(notbday) = [];
    otherwise   % The other frequencies; replace non-business days with previous days
        bdates(notbday) = busdate(bdates(notbday), -1, holvec);
    end
end

% Make sure the output is a column vector rather than a row vector
if isempty(bdates)
    bdates = [];
else
    bdates = bdates(:);
end

% [EOF]
