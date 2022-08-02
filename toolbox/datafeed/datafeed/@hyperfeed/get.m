function v = get(c,p)
%GET    Get Hyperfeed connection properties.
%   V = GET(C,'PropertyName') returns the value of the specified 
%   properties for the Hyperfeed connection object.  'PropertyName' is
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
%   See also HYPERFEED, CLOSE, FETCH, ISCONNECTION.

%   Author(s): C.F.Garvin, 05-24-2000
%   Copyright 1999-2003 The MathWorks, Inc.
%   $Revision: 1.4.2.2 $   $Date: 2004/04/06 01:06:02 $

%Build properties if none are given   
prps = {'connection';...
    'majorversion';...
    'minorversion';...
    'release';...
    'serialnumber';...
    'table';...
  };

%Check input properties for invalid entries
if nargin == 1
  
  p = prps;     %Use default property list
  x = (1:6);    %Default index scheme
  
else
  
  if ischar(p)   %Convert string input to cell array
    p = {p};
  end

  for i = 1:length(p)  %Validate each given property
    try
      x(i) = find(strcmp(upper(p(i)),upper(prps)));
    catch
      error('datafeed:hyperfeed:invalidProperty','Invalid %s connection property: '' %s ''.',class(c),p{i})
    end
  end

  p = prps(x);
  
end

%Get property flag = 3
mexflag = 4;

%Get all fields from API
tmp = hpdatafeed(4,c.connection);

%Add connection and table fields
tmp = setfield(tmp,'connection',c.connection);
tmp = setfield(tmp,'table',c.table);

%Return requested fields
for i = 1:length(x)
  eval(['v.' p{i} ' = tmp.' p{i} ';'])
end

%Single field returns value only
if length(x) == 1
  eval(['v = v.' char(p) ';'])
end
