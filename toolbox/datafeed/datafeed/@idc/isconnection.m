function x = isconnection(c)
%ISCONNECTION True if valid IDC connection.
%   X = ISCONNECTION(C) returns 1 if C is a valid IDC connection
%   and 0 otherwise.
%
%   See also IDC, CLOSE, FETCH, GET.

%   Author(s): C.F.Garvin, 12-15-99
%   Copyright 1999-2002 The MathWorks, Inc.
%   $Revision: 1.5 $   $Date: 2002/04/14 16:24:04 $

%Get the connected property from the connection handle
connstate = get(c,'Connected');

%Equate Yes to 1 and No or other state to 0
switch connstate
  
  case 'Yes'
  
    x = 1;
    
  otherwise 
    
    x = 0;
    
end
