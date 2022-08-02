function d = eomdate(y,m) 
%EOMDATE Last date of month. 
%   D = EOMDATE(Y,M) returns the last date of the month, in serial
%   form, for the given year, Y, and month, M.  
% 
%   For example, d = eomdate(1997,2) returns d = 729449 which is the serial
%   date corresponding to February 28, 1997.
%
%   See also DAY, EOMDAY, LBUSDATE, MONTH, YEAR. 
 
%        Author(s): C.F. Garvin, 01-04-96
%   Copyright 1995-2002 The MathWorks, Inc. 
%        $Revision: 1.7 $   $Date: 2002/04/14 21:49:44 $

if nargin < 2 
  error('Please enter Y and M.') 
end 
if checkrng('m',m,1,12,'1','12','e','e',mfilename)
  return
end

if length(y)==1;y = y(ones(size(m)));end   % scalar expansion
if length(m)==1;m = m(ones(size(y)));end
if length(y)==1;y = y(ones(size(m)));end   
if checksiz([size(y);size(m)],mfilename)
  return
end

ld = eomday(y,m);
d = datenum(y,m,ld);
