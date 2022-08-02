function dom = day(d) 
%DAY  Day of month. 
%   DOM = DAY(D) returns the day of the month given a serial date number 
%   or date string, D. 
% 
%   For example, dom = day(728647) or dom = day('19-Dec-1994') 
%   returns dom = 19. 
%  
%   See also MONTH, YEAR.
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:50:17 $ 
 
if nargin < 1 
  error('Please enter D.') 
end 
if isstr(d) 
  d = datenum(d); 
end 
c = datevec(d(:));           % Generate date vectors from dates 
dom = c(:,3);            % Extract day of month 
if ~isstr(d) 
  dom = reshape(dom,size(d)); 
end
