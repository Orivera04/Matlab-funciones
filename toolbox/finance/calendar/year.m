function y = year(d) 
%YEAR Year of date. 
%   Y = YEAR(D) returns the year of a serial date number or a date string, D. 
% 
%   For example, y = year(728647) or y = year('19-Dec-1994') returns y = 1994. 
%  
%   See also DATEVEC, DAY, MONTH. 
 
%   Author(s): C.F. Garvin, 2-23-95 
%   Copyright 1995-2002 The MathWorks, Inc.  
%   $Revision: 1.6 $   $Date: 2002/04/14 21:50:20 $ 
 
if nargin < 1 
  error('Please enter D.') 
end 
if isstr(d) 
  d = datenum(d); 
end 
 
c = datevec(d(:));          % Generate date vectors from dates 
y = c(:,1);             % Extract years  
if ~isstr(d) 
  y = reshape(y,size(d)); 
end 

