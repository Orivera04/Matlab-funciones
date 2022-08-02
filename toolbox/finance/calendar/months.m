function mm = months(d1,d2,eom)
%MONTHS Number of whole months between dates.
%   MM = MONTHS(D1,D2,EOM) returns the number of whole months between two 
%   dates, D1 and D2. EOM determines if dates corresponding to the last day
%   of the month are treated as an additional whole month (EOM = 1, default) 
%   or not (EOM = 0).
%         
%   For example, mm = months('31-march-1997','30-Jun-1997',1) returns mm = 3, 
%   and mm = months('31-march-1997','30-Jun-1997',0) returns mm = 2.
%
%   See also YEARFRAC.

%   Author(s): C.F. Garvin, 1-09-96
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.7 $   $Date: 2002/04/14 21:49:56 $

if nargin < 2
  error('Please enter D1 and D2.')
end

if nargin < 3              % Default EOM value is 1
  eom = 1;
end

if eom ~=1 & eom ~=0
  error('EOM must be 0 or 1.')
end

if isstr(d1)                % Convert date strings if necessary
  dat1 = datenum(d1);
  dat2 = datenum(d2);
else
  dat1 = d1;
  dat2 = d2;
end

% Scalar expansion
if length(dat1)==1, dat1=dat1(ones(size(eom))); end
if length(dat2)==1, dat2=dat2(ones(size(dat1))); end
if length(eom)==1, eom=eom(ones(size(dat2))); end
if length(dat1)==1, dat1=dat1(ones(size(eom))); end

if checksiz([size(dat1);size(dat2);size(eom)],mfilename)
  return
end
 
nindex = find(dat2 < dat1); % Manipulate data for negative output
temp1 = dat1(nindex);
temp2 = dat2(nindex);
dat1(nindex) = temp2;
dat2(nindex) = temp1;

year2 = year(dat2);
mont2 = month(dat2);
day2 = day(dat2);
yrs = (year2-year(dat1))*12;  % Find years between dates
mts = mont2-month(dat1);      % Find months between dates
dys = day2-day(dat1);          % Find days between dates
ld = eomday(year2,mont2);     % Find last day of month of D2
mincr = -ones(size(day2));
index = find(day2 >= day(dat1) | (ld == day2 & eom == 1)); 
mincr(index) = zeros(size(index)); % Do not subtract month if applicable

mm = mts+yrs+mincr;                   % Months calculation
mm(nindex) = -mm(nindex).*ones(size(nindex));  % Make negative if D2 < D1
