function b = subsref(a,s)
%SUBSREF Subscripted reference for Datafeed Toolbox IDC object.

%   Author(s): C.F.Garvin, 06-21-99
%   Copyright 1999-2002 The MathWorks, Inc.
%   $Revision: 1.5 $   $Date: 2002/04/14 16:24:07 $

tmp = struct(a);    %Get object structure

%Need calls to check queued and status fields

switch s(1).type
  
  case '.'     %Access fields of object
    eval(['b = tmp.' s(1).subs ';'])
    
  otherwise    %Return object
    b = tmp;
    
end
