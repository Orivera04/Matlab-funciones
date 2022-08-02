function t = today() 
%TODAY Current date. 
%   T = TODAY returns the current date.
%
%   See also CLOCK, DATENUM, DATESTR, NOW. 
 
%    Author(s): C.F. Garvin, 2-23-95 
%    Copyright 1995-2002 The MathWorks, Inc.  
%    $Revision: 1.6 $   $Date: 2002/04/14 21:50:14 $ 
 
c = clock; 
t = datenum(c(1),c(2),c(3)); 

