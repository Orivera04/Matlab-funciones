function v = get(c,p)
%GET    Get IDC connection properties.
%   V = GET(C,'PropertyName') returns the value of the specified 
%   properties for the IDC connection object.  'PropertyName' is
%   a string or cell array of strings containing property names.
%
%   V = GET(C) returns a structure where each field name is the name
%   of a property of C and each field contains the value of that 
%   property.
%
%   The property names are:
%
%   connected
%   connection
%   queued   
%
%   See also IDC, CLOSE, FETCH, ISCONNECTION.

%   Author(s): C.F.Garvin, 02-19-99
%   Copyright 1999-2003 The MathWorks, Inc.
%   $Revision: 1.7.2.2 $   $Date: 2004/04/06 01:06:05 $

%Build properties if none are given   
prps = {'connected';...
    'connection';...
  };

%Check input properties for invalid entries
if nargin == 1
  
  p = prps;     %Use default property list
  x = (1:3);    %Default index scheme
  
else
  
  if ischar(p)   %Convert string input to cell array
    p = {p};
  end

  for i = 1:length(p)  %Validate each given property
    try
      x(i) = find(strcmp(upper(p(i)),upper(prps)));
    catch
      error('datafeed:idc:invalidProperty','Invalid %s connection property: '' %s ''.',class(c),p{i})
    end
  end

  p = prps(x);
  
end

%Status command flag = 4 
idcflag = 4;

%Make idcdatafeed status call
tmp = idcdatafeed(4,'rpq,status');

%Fill structure
for i = 1:length(x)
  switch x(i)
    case 1   %Connected value is 2nd element of tmp
      eval(['v.' p{i} ' = tmp{2};'])
    case 2   %Connection value is already in structure of object
      eval(['v.' p{i} ' = c.' p{i} ';']) 
  end
end  

if length(x) == 1
  eval(['v = v.' char(p) ';'])
end
