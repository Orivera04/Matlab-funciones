function d = fetch(c,s,varargin)
%FETCH Request data from Yahoo.
%   D = FETCH(C,S) returns data for all fields from the Yahoo's web site for
%   given securities, S, given the connection handle, C.  
%
%   D = FETCH(C,S,F) returns the data for the specified fields, F.
%
%   D = FETCH(C,S,D1) returns all data fields for the given security for 
%   the date D1.  If D1 is today's date, the data from yesterday will
%   be returned.
%
%   D = FETCH(C,S,F,D1) returns the data for the specified fields, F, for the 
%   date D1.
%
%   D = FETCH(C,S,D1,D2) returns the data for the given security
%   for the date range D1 to D2.
%
%   D = FETCH(C,S,F,D1,D2) returns the data for the specified fields, F,
%   for the date range D1 to D2.
%
%   D = FETCH(C,S,D1,D2,P) returns the data for the given security
%   for the date range D1 to D2 with a period of P.   P can be
%   entered as:
%
%   'd' for daily values.
%   'w' for weekly values.
%   'm' for monthly values.
%   'v' for dividends.
%
%   See also YAHOO, CLOSE, GET, ISCONNECTION.

%   Author(s): C.F.Garvin, 02-25-00
%   Copyright 1999-2002 The MathWorks, Inc.
%   $Revision: 1.12.2.4 $   $Date: 2004/04/10 23:14:59 $

%Input argument checking
if nargin < 2
  error('datafeed:yahoo:fetchInputError','Connection object and security list required.')
end

%Validate security list.  Security list should be cell array string
if ischar(s)   
  s = cellstr(s);
end
if ~iscell(s) | ~ischar(s{1})
  error('datafeed:yahoo:securityInputError','Security list must be cell array of strings.')
end

%Get initial url from connection handle
url = c.url;
  
%Check number of input arguments
numinputs = length(varargin);

%Parse inputs beyond if security if given
if numinputs > 0
    
  %Check if first input is flag, field, or date
  if isdate(varargin{1})       
    
    %If date, continue with no action
    
  elseif isdatafield(varargin{1},numinputs)

    %Reduce number of inputs by 1, set fields list, remove fields from input list 
    numinputs = numinputs - 1;
    if ischar(varargin{1})
      valflds = cellstr(varargin{1});
    else
      valflds = varargin{1};
    end
    varargin(1) = [];
      
  elseif isflag(varargin{1})
    
    %Reduce number of inputs by 1 (index past flag)
    numinputs = numinputs - 1;
    switch upper(varargin{1})
        
    case 'GETDATA'    %Fields requested for current data
    
        if ~isdatafield(varargin{2},numinputs)
          error('datafeed:yahoo:invalidField','Invalid field requested.')
        end
      
        %Fields to cell array
        if ischar(varargin{2})
          valflds = cellstr(varargin{2});
        else
          valflds = varargin{2};
        end
        
        %Index past fields input
        numinputs = numinputs - 1;
        
      case 'HISTORY'  %Historical data request
          
        %Remove data retrieval flag from input list
        varargin(1) = [];
        
        %Check if field requested and reset numinputs and valid field list
        if isdatafield(varargin{1},numinputs)
          if ischar(varargin{1})
            valflds = cellstr(varargin{1});
          else
            valflds = varargin{1};
          end
          
          %Index past fields input and remove fields from input list
          numinputs = numinputs - 1;
          varargin(1) = [];
          
        end
          
    end
    
  else
      
    error('datafeed:yahoo:inputError','Please specify valid date, field or retrieval flag.') 
    
  end
  
end

%Build appropriate URL string and get data
switch numinputs
    
  case 0
      
    %Securities input (with or without fields) only, get default data
    
    %Start building url
    fetchurl = [url '/d/quotes.csv?s='];
    
    %Add security strings to url
    for i = 1:length(s)
      fetchurl = [fetchurl s{i} '+'];
    end 
    
    %Strip off trailing + sign
    fetchurl(end) = [];
    
    %Add remaining format parameters to url string
    fetchurl = [fetchurl '&f=sl1d1t1c1ohgv&e=.csv'];
   
    %Retrieve and parse data
    tmpdat = wwwread(fetchurl,numinputs,c);
    
    %Convert data to cell array
    eval(['celldat = {' tmpdat '};'])
    
    %Convert cell array to structure
    try
      d.Symbol = celldat(:,1);
      d.Last = [celldat{:,2}]';
      d.Date = datenum(celldat(:,3));
      d.Time = datenum(celldat(:,4));
      d.Change = [celldat{:,5}]';
      d.Open = [celldat{:,6}]';
      d.High = [celldat{:,7}]';
      d.Low = [celldat{:,8}]';
      d.Volume = [celldat{:,9}]';
    catch
      error('datafeed:yahoo:invalidData','Invalid return data.  Please verify given security symbol.')
    end
        
    %Return only fields requested
    if exist('valflds')
      for i = 1:length(valflds)
        eval(['tmpd.' upper(valflds{i}(1)) lower(valflds{i}(2:end)) '= d.' upper(valflds{i}(1)) lower(valflds{i}(2:end)) ';'])
      end
      d = tmpd;
    end
  
  case 1
        
    %Ask for specific date (with or without fields)
    
    %Get date
    try
      d1 = datenum(varargin{1});
    catch
      error('datafeed:yahoo:invalidDate','Invalid input date.  Please check format of entered date.')
    end
  
    %Get date vectors
    if floor(d1) == floor(now)
      sd = datevec(d1-1);
      ed = datevec(d1);
    else
      sd = datevec(d1);
      ed = sd;
    end
   
    %Build url using Daily period
    fetchurl = buildurl(s,sd,ed,'D');
           
    %Retrieve and parse data
    [tmpdat,h] = wwwread(fetchurl,numinputs,c);
    
    %Convert data to cell array
    eval(['d = [' tmpdat '];'])
    
    %Return only specific fields if any requested
    if exist('valflds')
      d = specificfieldsrequest(upper(valflds),d,upper(h));
    end
           
  case {2,3}
      
    %Ask for date range (with or without fields) with periodicity
      
    %Get dates
    try
      d1 = datenum(varargin{1});
      d2 = datenum(varargin{2});
    catch
      error('datafeed:yahoo:invalidDate','Invalid input date.  Please check format of start and end dates.')
    end
       
    %Allow for any order of date input
    tmpsd = min(d1,d2);
    tmped = max(d1,d2);
    sd = datevec(tmpsd);
    ed = datevec(tmped);
      
    %Set periodicity if not given
    if numinputs == 2
      p = 'd';
    else
      p = varargin{3};  
    end
    
    %Validate period
    if ~any(strcmp(lower(p),{'d','w','m','v'}));
      error('datafeed:yahoo:invalidPeriod','Period must be d, w, m, or v.')
    end
  
    %Build url
    fetchurl = buildurl(s,sd,ed,p);
           
    %Retrieve and parse data
    [tmpdat,h] = wwwread(fetchurl,numinputs,c);
    
    %Historical data supported for single stock only
    if length(s) > 1
      warning('datafeed:yahoo:fetchWarning','Historical data fetch does not support multiple security input.  %s data returned.',s{1})
    end
    
    %Convert data to matrix, trap when data include dividend data
    try
      eval(['d = [' tmpdat '];'])
    catch
      i = findstr(tmpdat,13);   %find line feeds
      rs = diff(i);             %find differences in characters per line
      rd = find(rs < 35);       %find lines that don't have all field data, 40ish is magic number
      j = zeros(length(rd),1);
      for z = 1:length(rd)
        j(z) = find(i(rd(z)) == i);
      end
      tmpcomm = 'tmpdat([';
      for k = 1:length(j)
        tmpcomm = [tmpcomm 'i(j(' num2str(k) ')):i(j(' num2str(k) ')+1)-1,']; 
      end
      tmpcomm(end) = [];
      tmpcomm = [tmpcomm ']) = [];'];
      eval(tmpcomm);
      eval(['d = [' tmpdat '];'])
    end
     
    %Return only specific fields if any requested
    if exist('valflds')
      d = specificfieldsrequest(upper(valflds),d,upper(h));
    end
    
end

%% Subfunctions

function [retdat,headings] = wwwread(fetchurl,numinputs,c)
%WWWREAD Parse requested URL data.
%   RETDAT = WWWREAD(FETCHURL,NUMINPUTS,C) retrieves and performs some
%   preliminary data parsing given the url, FETCHURL.   NUMINPUTS
%   is the number of varargin's determining if a date range is returned.
%   C is the Yahoo connection object.

%Create stream
if isempty(c.ip)
  www = java.net.URL(fetchurl);
else
  www = java.net.URL('http',c.ip,c.port,fetchurl);
end
is = www.openStream;

%Read stream of data
isr = java.io.InputStreamReader(is);
br = java.io.BufferedReader(isr);

%Parse return data
retdat = [];
next_line = toCharArray(br.readLine)';  %First line contains headings, determine length

%Delimiter is comma for all types of historical (used to be space for dividend data)
delim = ',';
headinglength = length(next_line)+1;

%Set datenum pivot year to make sure years are translated properly
v = datevec(now);
pivotyear = v(1) - 98;

%Loop through data
while ischar(next_line)
  
  retdat = [retdat, 13, next_line];
  tmp = br.readLine;
  try
    next_line = toCharArray(tmp)';
    if strcmp(next_line(1),'<')
      next_line = [];
    end
  catch
    break;
  end

  %Convert dates if historical data
  switch numinputs
     case {1,2,3}
       i = findstr(next_line,delim);
       try
         next_line = [num2str(datenum(next_line(1:i(1)-1),pivotyear)) next_line(i(1):end)];
       catch
       end  
  end
  
end

%Cleanup java objects
br.close; 
isr.close;
is.close;
  
%Convert double quotes to single quotes
i = find(retdat == '"');
retdat(i) = '''';

%Turn N/A into NAN
i = findstr(retdat,'N/A');
for j = 1:length(i)
   retdat(i(j):i(j)+2) = 'NaN';
end

%If date range requested, strip headings
switch numinputs
    
  case {1,2,3}
  
    %Save and remove headings
    b = retdat(1:headinglength);
    j = 1;
    while ~isempty(b)
      [a,b] = strtok(b,',');
      headings{j} = a;
      j = j + 1;
    end
    
    retdat(1:headinglength) = [];
    
end
    
function u = buildurl(s,sd,ed,p)
%BUILDURL Build URL for fetching data.
%   U = BUILDURL(S,SD,ED,P) builds the URL from which to retrieve
%   data for the symbol, S, given the start date, SD, and end date, ED.
%   P specifies the period of the return data.

u = ['http://chart.yahoo.com/table.csv?',...
                   '&a=' num2str(sd(2)-1) ...
                   '&b=' num2str(sd(3)) ...
                   '&c=' num2str(sd(1)) ...
                   '&d=' num2str(ed(2)-1) ...
                   '&e=' num2str(ed(3)) ...
                   '&f=' num2str(ed(1)) ...
                   '&s='  s{1},...
                   '&y=0',...
                   '&g=' p ...
                   '&ignore=.csv'];
                      
function x = specificfieldsrequest(f,d,h)
%SPECIFICFIELDSREQUEST Return only requested data fields.
%   X = SPECIFICFIELDSREQUEST(F,D,H) returns on the requested
%   fields, F, from the complete historical return data, D.
%   H is the list of field names returned by the fetch.

%Trap no data returned condition
if length(h) == 1 & ~isempty(findstr('NO PRICES',h{:}))
  error(h{:})
end

j = [1];              %Date is always returned for historical fetch
for i = 1:length(f)
  k = find(strcmp(f{i},h));
  if isempty(k)
    error('datafeed:yahoo:invalidField','Specified field %s not found for given security.',f{i})
  else
    j = [j find(strcmp(f{i},h))];
  end
end
x = d(:,unique(j));

function x = isdate(d)
%ISDATE True if input is date.
%   X = ISDATE(D) returns 1 if D is a valid date and 0 otherwise.

if isempty(d)   %if empty input, throw error
  error('datafeed:yahoo:inputError','Please specify valid date, field or retrieval flag.')   
end

try
  datenum(d);  %if datenum fails, invalid date
  x = 1;
catch
  x = 0;
end

function x = isdatafield(f,n)
%ISDATAFIELD True if input is valid data field.
%   X = ISDATAFIELD(F,D) returns 1 if F is a valid data
%   field and 0 otherwise.  N is the number of input arguments
%   that determines if a date has been passed signaling whether
%   to check the current or historical data field list.

%Load yahoo field lists
load yahoo/yhfields

%Convert field list to cell array 
if (ischar(f) | ischar(f{1}))
  f = cellstr(f);
else
  %Input is number, not a field
  x = 0;
  return
end

%Determine field list to match
if n == 1
  %No date given, use current data field list
  flds = yahoofieldnames;
  otherflds = histyhfieldnames;
  badflderr = 'Historical data field specified but current data requested.';
else
  %Date argument given, use historical data field list
  flds = histyhfieldnames;
  otherflds = yahoofieldnames;
  badflderr = 'Current data field specified but historical data requested.';
end

%Verify fields, any invalid field in list will return false
x = 1;
for i = 1:length(f)
  x = (x & any(strcmp(upper(f{i}),upper(flds))));
end

%If invalid field, check that field from wrong list was not given
%and throw more informative error
if ~x
  for i = 1:length(f)
    if any(strcmp(upper(f{i}),upper(otherflds)))
      error('datafeed:yahoo:fieldError','%s',badflderr)
    end
  end
end
    
function x = isflag(f)
%ISFLAG True if input is valid data retrieval flag.
%   X = ISFLAG(F) returns 1 is F is 'GETDATA' or 'HISTORY' and
%   0 otherwise.

%Only fields should be entered as cell array
if iscell(f), x = 0; return, end

switch upper(f)
  case {'GETDATA','HISTORY'}
    x = 1;
  otherwise
    x = 0;
end
