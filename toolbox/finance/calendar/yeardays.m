function nd = yeardays(y)
%YEARDAYS Number of days in year.
%   ND = YEARDAYS(Y) returns the number of days in a given year, Y.
%
%   For example, nd = yeardays(2000) returns 366.
%
%   See also DAYS360, DAYS365, DAYSACT, YEAR, YEARFRAC.

%   Author(s): C.F. Garvin, 1-08-96
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.7 $   $Date: 2002/04/14 21:51:00 $

if isstr(y)
  error('Input is string. Use YEAR to extract years from dates if necessary.')
end 

if checktyp('y',y,'int',mfilename)
  return
end

mts_dys = ones(size(y));        % Month and day values to pass to datenum function
next_y = y+1;                   % Next year values
first = datenum(y,mts_dys,mts_dys);      % Start date
last = datenum(next_y,mts_dys,mts_dys);  % End date
nd = last-first;
