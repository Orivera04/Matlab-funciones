function v = get(c,p)
%GET    Get Bloomberg connection properties.
%   V = GET(C,'PropertyName') returns the value of the specified 
%   properties for the Bloomberg connection object.  'PropertyName' is
%   a string or cell array of strings containing property names.
%
%   V = GET(C) returns a structure where each field name is the name
%   of a property of C and each field contains the value of that 
%   property.
%
%   The property names are:
%
%   connection
%   ipaddress
%   port
%   socket
%   version   
%
%   See also BLOOMBERG, CLOSE, FETCH, ISCONNECTION.

%   Author(s): C.F.Garvin, 02-19-99
%   Copyright 1999-2003 The MathWorks, Inc.
%   $Revision: 1.10.2.2 $   $Date: 2004/04/06 01:06:01 $

%Build properties if none are given   
prps = {'connection';...
    'ipaddress';...
    'port';...
    'socket';...
    'version';... 
  };

%Check input properties for invalid entries
if nargin == 1
  
  p = prps;     %Use default property list
  x = (1:5);    %Default index scheme
  
else
  
  if ischar(p)   %Convert string input to cell array
    p = {p};
  end

  for i = 1:length(p)  %Validate each given property
    try
      x(i) = find(strcmp(upper(p(i)),upper(prps)));
    catch
      error('datafeed:bloomberg:invalidProperty','Invalid %s connection property: '' %s ''.',class(c),p{i})
    end
  end

  p = prps(x);
  
end

%Get property flag = 3
bbflag = 3;

%Make appropriate bb_ api calls to get properties, 3 is get flag, x(i) is property flag.
for i = 1:length(x)
  switch x(i)
    case {1}
      eval(['v.' p{i} ' = bbdatafeed(bbflag,' num2str(x(i)) ',c.connection);'])
    case {2,3}
      eval(['v.' p{i} ' = c.' p{i} ';'])
    case {4,5}
      eval(['v.' p{i} ' = bbdatafeed(bbflag,' num2str(x(i))-2 ',c.connection);'])
  end
end

if length(x) == 1
  eval(['v = v.' char(p) ';'])
end
