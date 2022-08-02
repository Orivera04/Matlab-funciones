function jt = str2jt(line)

% STR2JT - Convert date-time string to Julian Time.
% jt = str2jt(line)
%
% Converts a date-time string to Julian time, in days.  Julian 
% days are a continuous count of days starting from noon Univeral 
% Time on January 1 of the year 4713 BC, a reference useful in 
% astronomical formulas.  (Note: 0:00 UT corresponds to a Julian 
% time fraction of 0.5.)  Input 'line' is a string variable 
% having any of the following formats:
%
%              FORMAT                  EXAMPLE
%              ------                  -------
%             'dd-mmm-yyyy HH:MM:SS'   01-Mar-1995 15:45:17
%             'dd-mmm-yyyy'            01-Mar-1995
%             'mm/dd/yy'               03/01/95
%             'mm/dd'                  03/01
%             'mmmyy'                  Mar95
%             'HH:MM:SS'               15:45:17
%             'HH:MM:SS PM'             3:45:17 PM
%             'HH:MM'                  15:45
%             'HH:MM PM'                3:45 PM
%
% (Variations on date and time can be combined.)
%
% P.G. Bonanni
% 7/19/00


% Extract components of date/time string
[Year,Month,Day,Hour,Min,Sec] = datevec(line);

% Convert to Julian Time 
% (Algorithm from Meeus, J., Astronomical Algorithms)

if (Month<3)
  Year = Year-1;
  Month = Month+12;
end

A = fix(Year/100);
B = 2 - A + fix(A/4);

jt = fix(365.25 * (Year + 4716)) + fix(30.6001 * (Month + 1)) + ...
     Day + B - 1524.5 + Hour/24 + Min/24/60 + Sec/24/60/60;
