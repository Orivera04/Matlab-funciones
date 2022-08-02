function s = second(d) 
%SECOND Seconds of date or time. 
%   S = SECOND(D) returns the seconds given a serial date number or a 
%   date string, D. 
%        
%   For example, s = second(728647.558427893) or  
%   s = second('19-Dec-1994, 13:24:08.17') returns s = 8.17. 
%   
%   See also DATEVEC, MINUTE, HOUR. 
  
%   Author(s): C.F. Garvin, 2-23-95 
%   Copyright 1995-2002 The MathWorks, Inc.  
%   $Revision: 1.6 $   $Date: 2002/04/14 21:50:02 $ 
 
if nargin < 1 
  error('Please enter D.') 
end 
if isstr(d) 
  d = datenum(d); 
end 
 
c = datevec(d(:));      % Generate date vectors from dates 
s = c(:,6);         % Extract seconds 
if ~isstr(d) 
  s = reshape(s,size(d)); 
end
