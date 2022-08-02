function d = lweekdate(wkd,y,m,g)
%LWEEKDATE Date of last occurrence of weekday in month.
%   D = LWEEKDATE(WKD,Y,M,G) returns the date, in serial form, of the
%   last occurrence of a given weekday in a given month. WKD is the
%   weekday, (1 through 7 equal Sunday through Saturday), Y is the year, 
%   M is the month, and G specifies a weekday that must fall after WKD
%   in the same week.  
%
%   For example, to find the last Monday in June 1997:
%
%      d = lweekdate(2,1997,6) returns 729571 which is the serial 
%          date corresponding to Jun 30, 1997. 
%      
%   See also EOMDATE, LBUSDATE, NWEEKDATE.

%        Author(s): C.F. Garvin, 01-08-96
%   Copyright 1995-2002 The MathWorks, Inc. 
%        $Revision: 1.7 $   $Date: 2002/04/14 21:50:57 $

if nargin < 3 
  error('Please enter WKD, Y, and M.') 
end 

if nargin < 4
  g = 0;
end

if any(any(m > 12 | m < 1)) 
  error('M must be greater than 0 and less than 13.') 
end 

if any(any(wkd > 7 | wkd < 1))
  error('WKD must be integer value of 1 through 7.')
end 

if any(any(g > 7 | g < 0))
  error('G must be integer value of 0 through 7.')
end 

% Scalar expansion
if length(wkd)==1,wkd=wkd(ones(size(g)));end
if length(y)==1,y=y(ones(size(wkd)));end
if length(m)==1,m=m(ones(size(y)));end
if length(g)==1,g=g(ones(size(m)));end
if length(wkd)==1,wkd=wkd(ones(size(g)));end

mvec = zeros(42,1);
dvec = zeros(42,1);
d = zeros(size(wkd));
ld = eomday(y,m);
fst = datenum(y,m,ones(size(y)));
lst = datenum(y,m,ld);
wd = weekday(fst);
x = ld+wd-1;
for j = 1:length(wkd(:))
  mvec(wd(j):x(j)) = fst(j):lst(j);
  dvec(wd(j):x(j)) = weekday(mvec(wd(j):x(j)));
  mmat = reshape(mvec,7,6)';
  dmat = reshape(dvec,7,6)';
  dindex = find(dmat == wkd(j));
  gindex = find(dmat == g(j));
  dweek = rem(dindex,6);
  i = find(dweek == 0);
  dweek(i) = 6*ones(size(i));
  gweek = rem(gindex,6);
  i = find(gweek == 0);
  gweek(i) = 6*ones(size(i));
  if gweek(length(gweek)) == dweek(length(dweek)) | g(j) == 0
    d(j) = mmat(max(dindex));
  else
    d(j) = mmat(max(dindex))-7;
  end
  mvec = mvec*0;
  dvec = dvec*0;
end
