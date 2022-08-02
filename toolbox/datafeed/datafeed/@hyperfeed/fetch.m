function d = fetch(c,s,varargin)
%FETCH Request data from Hyperfeed.
%   X = FETCH(C,S) returns data for the security S given a connection handle 
%   for one of the supported Hyperfeed databases.  The returned data includes
%   all fields and/or dates relevant to the selected database.
%
%   X = FETCH(C,S,F) returns data for the fields, F.
% 
%   X = FETCH(C,S,D) returns data for the date, D.
%
%   X = FETCH(C,S,D1,D2) returns data for the date range specified by D1 and D2.
%
%   X = FETCH(C,S,F,D) returns data for the fields, F, and date, D.
%
%   X = FETCH(C,S,F,D1,D2) returns data for the fields, F, and the date range
%   specified by D1 and D2.
%
%   Date inputs apply only to History database connections.  For the Time Series database, all
%   fields, LAST, BID, and ASK, are always returned.
%
%   See also HYPERFEED, CLOSE, GET, ISCONNECTION.

%   Author(s): C.F.Garvin, 05-04-00
%   Copyright 1999-2002 The MathWorks, Inc.
%   $Revision: 1.8 $   $Date: 2002/04/14 16:23:05 $

%Input argument checking
if nargin < 2
  error('Connection object and security list required.')
end

%Validate string inputs, (security, exchange, country, currency)
s = validateinput(s);
nvarargin = length(varargin);

%Determine country input
cou = cell(length(s),1);
for i = 1:length(s)
  j = findstr(s{i},' ');
  if isempty(j)
	cou{i} = 'US';
  else
	cou{i} = s{i}(j+1:end);
	s{i} = s{i}(1:j-1);
  end
end
	
%Get data, connection field contains table number
%Table number determines hpdatafeed calling syntax
switch c.connection
    
  case 3    %Price table request
    
    %Current price data request flag
    mexflag = 2;
    
    %Request data
    d = hpdatafeed(mexflag,c.connection,length(s),s,cou);
  
    %Clean up strings
    d.PrimaryExchange = cleanupdat(d.PrimaryExchange,1);
    d.LastExchange = cleanupdat(d.LastExchange,1);
    d.OpenExchange = cleanupdat(d.OpenExchange,1);
    d.HighExchange = cleanupdat(d.HighExchange,1);
    d.LowExchange = cleanupdat(d.LowExchange,1);
    d.YesterdayExchange = cleanupdat(d.YesterdayExchange,1);
    d.BidExchange = cleanupdat(d.BidExchange,1);
    d.AskExchange = cleanupdat(d.AskExchange,1);
    
  case 7    %Price TimeSeries table request

    %Timeseries price data request flag
    mexflag = 3;
    
    %Request data
    d = hpdatafeed(mexflag,c.connection,length(s),s,cou);
    
    %Filter out Delete and End records
    i = find(d(:,1) == 128);
    if ~isempty(i),d(i,:) = [];end
    i = find(d(:,6) == 255);
    if ~isempty(i),d(i,:) = [];end

    %If d is empty, return empty array
    if isempty(d)
      d = [];
      return
    end
    
    %Convert hour, minute, second into date numbers
    d(:,4) = datenum(0,0,0,d(:,4),d(:,5),d(:,6));
    d(:,5:6) = [];
    
  case 9  %History table request
  
    mexflag = 5;
    
    %Request data
    d = hpdatafeed(mexflag,c.connection,length(s),s,cou);
    
    %Find first 0 value and remove everything after that point
    i = find(d(:,1) == 0);
    d(i:end,:) = [];
    
    %Convert the first column from number of seconds since Jan 1, 1970 to datenumber
    secperday = 60 * 60 * 24;
    d(:,1) = floor(datenum(1970,1,1) + d(:,1) ./ secperday);
    
	%Parse inputs to return proper fields and date ranges
	
	numinputs = length(varargin);
	switch numinputs
		
	  case 0
	    %All available data, D, returned
		
	  case 1 %Either field or date given
		  
		 if isdate(varargin{1})   %Date given, return all fields for date
		   
		   %Return data for exact or closest matching date
		   i = max(find(d(:,1) <= datenum(varargin{1})));
		   if isempty(i)
			 i = min(find(d(:,1) >= datenum(varargin{1})));
		   end
		   d = d(i,:);
		   
	     else                     %Field given, return all dates for given field
		   f = validateinput(varargin{1});            %Field list to cell array
		   d = fieldrange(d,f);                       %Get only specified fields
	     end

	   case 2  %Either field and date or two dates given
		   
		 if isdate(varargin{1})
		   d = daterange(d,varargin{1},varargin{2});  %Get data for given date range
	     else
		   f = validateinput(varargin{1});            %Field list to cell array
		   d = fieldrange(d,f);                       %Get only specified fields
		   
		   %Return data for exact or closest matching date
		   i = max(find(d(:,1) <= datenum(varargin{2})));
		   if isempty(i)
			 i = min(find(d(:,1) >= datenum(varargin{2})));
		   end
		   d = d(i,:);
	     end
		   
	   case 3  %Field and date range given
		   
		 d = daterange(d,varargin{2},varargin{3});  %Get data for given date range
		 f = validateinput(varargin{1});            %Field list to cell array
		 d = fieldrange(d,f);                       %Get only specified fields
		 
	 end
	     
  case 52  %Profile table request
  
    mexflag = 6;
    
    %Number of securities
    numsec = length(s);
    
    %Request data
    d = hpdatafeed(mexflag,c.connection,numsec,s,cou);
    
    %Cleanup CUSIP data
    d.CusipNumber = cleanupdat(d.CusipNumber,9);
    
    %Convert last update field to date
    tmp = cell(numsec,1);
    for x = 1:numsec  
        
      lutmp = fliplr(dec2bin(d.LastUpdate(x)));
      i = find(lutmp(1:8) == '1');
      daytmp = 0;
      for j = 1:length(i)
        daytmp = daytmp + 2 ^ (i(j)-1);
      end
      i = find(lutmp(9:end) == '1');
      mthtmp = 0;
      for j = 1:length(i)
        mthtmp = mthtmp + 2 ^ (i(j)-1);
      end
      if length(mthtmp) == 1, delim = '/0'; else, delim = '/'; end
      tmp{x} = [num2str(daytmp) delim num2str(mthtmp)];    
    
    end
  
    d.LastUpdate = tmp;
    
    %Convert date vectors to date numbers
    tmpDiv = zeros(numsec,1);
    tmpExp = tmpDiv;
    tmpRaw = tmpExp;
    for i = 1:numsec
      tmpDiv(i) = datenum(d.DivDate(1,i),d.DivDate(2,i),d.DivDate(3,i));
      tmpExp(i) = datenum(d.ExpDate(1,i),d.ExpDate(2,i),d.ExpDate(3,i));
      tmpRaw(i) = datenum(d.RawMatDate(1,i),d.RawMatDate(2,i),d.RawMatDate(3,i));
    end
    
    d.DivDate = tmpDiv;
    d.ExpDate = tmpExp;
    d.RawMatDate = tmpRaw;
    
  otherwise
      
    error('Database table not currently supported.')
    
end

%For price and profile tables, return specific fields if requested
if length(varargin) == 0
  return
end
	
switch c.connection
	
  case {3,52}
	  
	%Get full field list
	flds = fieldnames(d);
	
	f = validateinput(varargin{1});   %Requested fields
	
    %S&PCode field is special case, & makes various M-code fail
    if any(strcmp(f,'S&PCode'))
      spcode = getfield(d,{1,1},{'S&PCode'},{1:length(d.CusipNumber)});
      d = rmfield(d,'S&PCode');
    end
    
    j = zeros(length(f),1);
	for i = 1:length(f)
	  j(i) = find(strcmp(upper(f{i}),upper(flds)));
	  if isempty(j)
		error(['Invalid field - ' f{i}])
      end
    end
    flds(j) = [];
    if ~isempty(flds)
	  d = rmfield(d,flds);
    end
    
    if exist('spcode')
      d.SandPCode = spcode;
    end
    
end
	

%%Subfunctions

function x = validateinput(y)
%VALIDATEINPUT
%   X = VALIDATEINPUT(Y) validates security, exchange, country and currency
%   inputs.   Inputs are converted to cell string arrays.  

try
  if ~iscell(y) & ischar(y)   
    x = cellstr(y);
  else
	x = y;
  end
catch
  error('Input must be string or cell array of strings.')
end

function x = isdate(z)
%ISDATE True if input is date.
%   X = ISDATE(D) returns 1 if D is a valid date and 0 otherwise.

if isempty(z)   %if empty input, throw error
  error('Please specify valid date, field or retrieval flag.')  
end

try
  datenum(z);  %if datenum fails, invalid date
  x = 1;
catch
  x = 0;
end

function a = daterange(b,d1,d2)
%DATERANGE Data for given date range.

d1 = datenum(d1);
d2 = datenum(d2);

try
  i(1) = min(find(b(:,1) >= min(d1,d2)));
  i(2) = max(find(b(:,1) <= max(d1,d2)));
catch
  error('No data for given date range.')
end
a = b(i(1):i(2),:);

function a = fieldrange(b,f)
%FIELDRANGE Data for given field list.

i = [];
for j = 1:length(f)	
  i = [i find(strcmp(upper(f{j}),{'DATE','OPEN','HIGH','LOW','CLOSE','VOLUME'}))];
  if isempty(i)
	error('Valid historical data fields are DATE, OPEN, HIGH, LOW, CLOSE, and VOLUME');
  end
end
a = b(:,[1,i]);

function y = cleanupdat(x,n)
%CLEANUPDAT Remove trailing characters from data.
%   Y = CLEANUPDAT(X,N) removes the trailing characters from X
%   returning only the first N characters from each row.

tmp = char(x);
y = cellstr(tmp(:,1:n));
