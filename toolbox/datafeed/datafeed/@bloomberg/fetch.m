function d = fetch(c,s,r,varargin)
%FETCH Request data from Bloomberg communications server.
%   D = FETCH(C,S,R) returns data from the Bloomberg communications server for
%   given securities.  Data returned can be header data, fields for a single
%   security, or all ticks for a specified day.  R specifies the type of data 
%   request to send to the server.   R can be 'header', 'getdata', 'ticks', 
%   'timeseries', or 'history'.  The default request type is 'header'.
%
%   D = FETCH(C,S) returns the header field data for the security S using the 
%   DEFAULT search option.
%
%   D = FETCH(C,S,'HEADER','DEFAULT') returns the header field data filling all
%   fields with data from the most recent date with a bid, ask, or trade.   This
%   command is the equivalent of D = FETCH(C,S).
%
%   D = FETCH(C,S,'HEADER','TODAY') returns the header field data with data from
%   today only.
%
%   D = FETCH(C,S,'HEADER','ENHANCED') returns the header field data for the 
%   most recent date of each individual field.   In this case, for example, 
%   the bid and ask group fields could come from different dates.
%
%   D = FETCH(C,S,'GETDATA',F) returns the data for the fields F for the 
%   security list, S.   Load the file bloomberg/bbfields to see the list of 
%   supported fields.
%
%   D = FETCH(C,S,'GETDATA',F,O,V) returns the data for the fields F for the 
%   security list, S, using the override settings denoted by the override field
%   list, O, and the corresponding override field values, V.
%
%   D = FETCH(C,S,'TIMESERIES',T) returns the tick data for the security S for
%   the date T.
%
%   D = FETCH(C,S,'TIMESERIES',T,B,F) returns the tick data for the security S for
%   the date T in intervals of B minutes for the field, F.  The field can be specified
%   as a string or numeric value.   For example, F = 'Trade' or F = 1 return data for 
%   ticks of type Trade.   The command DFTOOL('ticktypes') returns the list of intraday 
%   tick fields.   Intraday tick data requested with an interval is returned with the 
%   the columns representing Time, Open, High, Low, Value of last tick in bar, Volume
%   total value of ticks in bar, and Number of ticks in bar.
%
%   D = FETCH(C,S,'HISTORY',F,FROMDATE,TODATE,PER) returns the historical data for 
%   the field, F, for the dates FROMDATE to TODATE.  PER specifies the period of the data,
%   'd' - daily, 'w' - weekly, 'm' - monthly, 'q' - quarterly, 'y' - yearly.  If PER is not
%   specifed, the default period for the data will be used.
%
%   D = FETCH(C,STR,'LOOKUP',M) returns the list of matching securities given the
%   security search string, STR.
%
%   D = FETCH(C,S,'MONITOR','API') subscribes to a given security, S, and runs
%   runs the specified function, API.  The specified API function is any 
%   valid MATLAB function written to the data structure by the HEADER call.
%   The MONITOR loop is terminated by typing CONTROL-C at the keyboard.  The
%   current data for the security is returned in the header data format when
%   the loop is terminated.
%
%   D = FETCH(C,S,'MONITOR','API',N) subscribes to a given security, S, and runs
%   runs the specified function, API.  The specified API function is any 
%   valid MATLAB function written to the data structure by the HEADER call.
%   N defines the number of ticks to be processed before the MONITOR loop terminates.
%   This allows the user to automatically break out of the loop with no
%   keyboard input.  Typing CONTROL-C will terminate the MONITOR loop if
%   the number of processed ticks is less than N.
%
%   Examples:
%
%   D = FETCH(C,'ABC US Equity') returns the header data for the given security.
%
%   D = FETCH(C,'ABC US Equity','GETDATA',{'LAST_PRICE';'OPEN'}) returns
%   the opening and closing price of the given security.
%
%   D = FETCH(C,'3358ABCD4 Corp','GETDATA',{'YLD_YTM_ASK','ASK','OAS_SPREAD_ASK','OAS_VOL_ASK'},{'ASK','OAS_VOL_ASK'},{'99.125000','14.000000'})
%   returns the requested fields given override fields and values.
%
%   D = FETCH(C,'ABC US Equity','TIMESERIES',NOW) return today's time series
%   for the given security.  The tick flag, timestamp, tick value and size in 
%   shares of the transaction are returned.
%
%   D = FETCH(C,'ABC US Equity','TIMESERIES',NOW,5,'Trade') return today's trade time series
%   for the given security aggregated into 5 minute intervals.  
%
%   D = FETCH(C,'ABC US Equity','HISTORY','LAST_PRICE','8/01/99','8/10/99')
%   returns the closing price for the given dates for the given security using
%   the default period of the data.
%
%   D = FETCH(C,'ABC US Equity','HISTORY','LAST_PRICE','8/01/99','8/10/99','m')
%   returns the monthly closing price for the given dates for the given security.
%
%   D = FETCH(C,'Intl Bus Mac','LOOKUP','Equity') returns the securities along
%   with their ticker symbols matching the search string 'Intl Bus Mac' for the
%   Equity market. Valid market types are 'Comdty','Corp','Curncy','Equity',
%   'Index','Govt','M-Mkt','Mtge', 'Muni' and 'Pfd'.
%
%   D = FETCH(C,'ABC US Equity','MONITOR','monitor1') subscribes to the security
%   ABC US Equity and runs the function MONITOR1 each time a tick signal is 
%   received from Bloomberg.  The security is monitored until the user types
%   CONTROL-C.
%
%   D = FETCH(C,'ABC US Equity','MONITOR','monitor1',1000) subscribes to the security
%   ABC US Equity and runs the function MONITOR each time a tick signal is 
%   received from Bloomberg.  The security is monitored until the user types
%   CONTROL-C or until the total number of data requests answered by Bloomberg
%   is greater than 1000.
%
%   See also BLOOMBERG, CLOSE, GET, ISCONNECTION, MONITOR1, MONITOR2.

%   Author(s): C.F.Garvin, 02-19-99
%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.27.2.9 $   $Date: 2004/04/06 01:06:00 $

%Input argument checking
if nargin < 2
  error('datafeed:bloomberg:fetchInputError','Connection object and security list required.')
end

%Validate connection
if ~isconnection(c)
  error('datafeed:bloomberg:invalidConnection','Invalid Bloomberg connection.')
end

%Validate security list.  Security list should be cell array string
if ischar(s)   
  s = cellstr(s);
end
if ~iscell(s) | ~ischar(s{1})
  error('datafeed:bloomberg:securityInputError','Security list must be cell array of strings.')
end

%Build security type input (TICKER/Other = 0, CUSIP = 1)
sectype = zeros(length(s),1);
for i = 1:length(s)
    
  %Determine if CUSIP or other identifier
  tmp = str2double(s{i});     %all numeric input is CUSIP
  fch = str2double(s{i}(1));  %first assume that number as first character is CUSIP
  j = findstr(s{i},' ');   %Any spaces in security id denotes market id and not CUSIP
  if ~isempty(j) | (isnan(fch) & (isempty(tmp) | isnan(tmp))) 
    sectype(i) = 0;
  else
    sectype(i) = 1;
  end
end

%Default data retrieval method is HEADER
if nargin < 3
  r = 'HEADER';
end

%Convert data request to integer value
requesttypes = {'HEADER';'GETDATA';'TICKS';'HISTORY';'TIMESERIES';'LOOKUP';'MONITOR';'CLEAR'};
reqval = find(strcmp(upper(r),requesttypes));
if isempty(reqval)
  error('datafeed:bloomberg:dataRequestTypeError','Valid data request types are ''HEADER'', ''GETDATA'', ''TICKS'', ''HISTORY'', ''TIMESERIES'' , ''LOOKUP'', ''MONITOR'', or ''CLEAR''')
end

%Data retrieval flag = 4, switchyard value for bbdatafeed
bbflag = 4;

%Call bbdatafeed, reqval is data retrieval method switchyard value
switch reqval
  
  case 1  %HEADER
    
    %Determine the search flag value
    if length(varargin) < 1
      schflg = 1;   %Default search
    else
      schopts = {'DEFAULT';'TODAY';'ENHANCED'};
      schflg = find(strcmp(upper(varargin{1}),schopts));
      if isempty(schflg)
        error('datafeed:bloomberg:headerFlagError','Search flag value must be one of DEFAULT, TODAY or ENHANCED')
      end
    end
    
    %Get verbose bbdatafeed output flag
    verboseflag = parseverboseflag(2,varargin);
    
    %Get header data
    d = bbdatafeed(bbflag,reqval,c.connection,length(s),s,schflg,verboseflag,sectype);
    
    %Convert dates and times to MATLAB date numbers
    d = bbdatetime2mldatenum(d);
    
  case 2  %GETDATA
    
    if length(varargin) < 1
      error('datafeed:bloomberg:getdataFieldError','Please specify data fields to be returned.')
    end
    
    %Convert fieldnames to fieldids, override fields too,  Convert override values to strings
    [fids,f,ftypes] = getfieldids(1,varargin);
    if length(varargin) > 1
      [ovrfids,ovrf] = getfieldids(2,varargin);
      ovrvals = ovval2ovstr(varargin(2:end));
    else
      ovrfids = [];
      ovrvals = [];
    end 
    
    %Convert override values to strings
    if length(varargin) > 1
      ovrvals = ovval2ovstr(varargin(2:end));
    end
     
    %Get verbose bbdatafeed output flag
    verboseflag = parseverboseflag(4,varargin);
    
    %Number of securities
    numsec = length(s);
    numflds = length(fids);
    
    %Return data as double array
    tmp = cell(numflds,numsec);
    secmax = 10;
    fldmax = 50;
      
    %Loop through security list
    for i = 1:secmax:numsec
      
      %Step through security list in increments of 10 (or remaining securites at end)
      try
        ps = s(i:i+secmax-1);
        pstype = sectype(i:i+secmax-1);
      catch
        ps = s(i:end);
        pstype = sectype(i:end);
      end
      
      %Need number of securities being passed
      lps =  length(ps);
    
      %For current increment of securities, loop through fields
      for j = 1:fldmax:numflds
        
        try  %whole increment of 50 fields
          tmp(j:j+fldmax-1,i:i+lps-1) = bbdatafeed(bbflag,reqval,c.connection,fldmax,ps,fids(j:j+fldmax-1),verboseflag,lps,pstype,length(ovrfids),ovrfids,ovrvals);     
        catch  %remaining fields (less than 50)
          tmp(j:end,i:i+lps-1) = bbdatafeed(bbflag,reqval,c.connection,numflds-j+1,ps,fids(j:end),verboseflag,lps,pstype,length(ovrfids),ovrfids,ovrvals);    
        end
        
      end 
      
    end
  
    %Create cell array to hold parsed data
    alldat = cell(numflds,1);
    
    %Convert fields that are numeric to numbers (and NaN's where necessary)
    i = find(ftypes == 2 | ftypes == 3);   %2 is Bloomberg numeric, 3 is Bloomberg price
    for j = 1:length(i)
      alldat{i(j)} = str2double(tmp(i(j),:))';
    end
     
    %Parse bulk fields
    i = find(ftypes == 8);
    for j = 1:length(i)
      for k = 1:numsec
        tmp{i(j),k} = parsestring(tmp{i(j),k});
      end
      alldat{i(j)} = tmp(i(j),:)';
    end
     
    %Parse date/time fields
    i = find(ftypes == 5 | ftypes == 6 | ftypes == 7);   %5 = date, 6 = time, 7 = date/time
    for j = 1:length(i)
      for k = 1:numsec
        try
          tmp{i(j),k} = datenum(tmp{i(j),k});
          if isempty(tmp{i(j),k})
            tmp{i(j),k} = NaN;
          end
        catch
          tmp{i(j),k} = NaN;
        end
      end
      alldat{i(j)} = [tmp{i(j),:}]';
    end
    
    %Process remaining fields, 1 = string, 4 = security, 9 = mm/yyyy, 10 = boolean, 11 = ISO Currency Code (ASCII string)
    i = find(ftypes == 1 | ftypes == 4 | ftypes == 9 | ftypes == 10 | ftypes == 11);
    for j = 1:length(i)
      alldat{i(j)} = tmp(i(j),:)';
    end
    
    %Build the output structure
    for i = 1:numflds
      try
        d.(f{i}) = alldat{i};
      catch
        f{i} = ['d' f{i}];
        d.(f{i}) = alldat{i};
      end
    end
    
    %Convert dates and times to MATLAB date numbers
    d = bbdatetime2mldatenum(d);

  case 3  %TICKS
    
    reqval = 5;   %TICKS flag no longer working with Bloomberg

    %Get verbose bbdatafeed output flag
    verboseflag = parseverboseflag(1,varargin);
    
    %Get tick data, verboseflag must be 7th input, pad with two zero inputs
    d = bbdatafeed(bbflag,reqval,c.connection,s,0,0,verboseflag);
    
    %Convert time stamps to MATLAB date numbers
    if size(d,2) > 1
      hrs = (d(:,2)/3600)/24;   %3600 seconds in an hour, 24 hours in a day
      d(:,2) = hrs;
    end
    
    %Replace invalid data with NaN's
    j = find(d < 1e-9);
    d(j) = NaN;

  case 4  %HISTORY
    
    %Trap number of securities
    secmax = 8;
    numsec = length(s);
    
    %Get verbose bbdatafeed output flag
    verboseflag = parseverboseflag(5,varargin);
    
    %Convert fieldnames to fieldids
    [fids,f] = getfieldids(1,varargin);
    numflds = length(fids);
    maxflds = 4;
    if numflds > maxflds
      error('datafeed:bloomberg:maxInputs','Maximum number of fields for HISTORY call is %d.',maxflds);
    end
    
    %Convert dates to Bloomberg dates
    mldate = zeros(2,1);
    mldate(1) = datenum(varargin{2});
    mldate(2) = datenum(varargin{3});
    [yr,mn,dy] = datevec(mldate);
    dts = yr*10000 + mn*100 + dy;   %dts(1) is fromdate, dts(2) is todate
    
    %Determine the period value
    if length(varargin) > 3
      per = lower(varargin{4}(1));
    end
    prs = {'d';'w';'m';'q';'y'};
    if exist('per')
      perflag = strmatch(per,prs);
    end
    if ~exist('perflag') || isempty(perflag)
      perflag = 0;
    end
    
    %Loop through security list
    for i = 1:secmax:numsec
      
      %Step through security list in increments of 10 (or remaining securites at end)
      try
        ps = s(i:i+secmax-1);
        pstype = sectype(i:i+secmax-1);
        ind = i:i+secmax-1;
      catch
        ps = s(i:end);
        pstype = sectype(i:end);
        ind = i:numsec;
      end
      
      %Need number of securities being passed
      lps =  length(ps);
    
      %API call
      d(ind) = bbdatafeed(bbflag,reqval,c.connection,ps,fids,dts(1),verboseflag,dts(2),numflds,pstype,perflag,lps);
    
    end
    
    %Convert bloomberg dates into MATLAB date numbers
    for i = 1:length(d)
      yr = round(d{i}(:,1)/10000);
      mt = round(d{i}(:,1)/100) - yr*100;
      dy = round(mod(d{i}(:,1)/100,1) * 100);
      d{i}(:,1) = datenum(yr,mt,dy);
    end
     
    %Return matrix if only one security
    if (iscell(d) && length(d) == 1)
      d = d{1};
    end
      
  case 5  %TIMESERIES
    
    %Get date to compute date offset
    if length(varargin) < 1
      error('datafeed:bloomberg:missingTimeseriesDate','Please enter date for time series data retrieval.')
    end
    
    %Find Sundays and Saturdays and remove them
    daterng = floor(datenum(varargin{1})):floor(now);
    dnum = weekday(daterng);
    i = find(dnum == 1 | dnum == 7);   
    daterng(i) = [];
    offset = length(daterng)-1;  %Subtract 1 since today is a 0 offset
    
    %Increment offset if given date is Saturday or Sunday
    dval = weekday(varargin{1});
    if (dval == 1 | dval == 7)
      offset = offset + 1;
    end
    
    %Get verbose bbdatafeed output flag
    verboseflag = parseverboseflag(4,varargin);
       
    %Get bar size if given
    if length(varargin) > 1
      intval = ceil(varargin{2});
    else
      intval = 0;
    end
    
    %Get timeseries data, verboseflag is 7th input, pad with zero
    if intval
      
      %Get numeric values of given date, year, month, day of month, weekday number, yearday number
      tdate = floor(datenum(varargin{1}));
      [yrval, mtval, dyval] = datevec(tdate);
      yrval = yrval - 1900;        %TM structure uses 1900 as base date year
      mtval = mtval - 1;           %TM structure uses January = 0
      wkday = weekday(tdate)-1;    %Get weekday value (need to shift by -1 to conform with time structure in C code)
      yrday = tdate - datenum(yrval+1900,1,1) - 1;    %TM structure uses days since Jan 1 (need -1)
      
      %Get tick type
      if length(varargin) > 2
        ticktype = varargin{3};
      else
        ticktype = 1;   %Default request field is TRADE
      end
      
      %Convert tick type string value to numeric value if necessary
      if ischar(ticktype)
        ttypes = upper(dftool('ticktypes'));
        j = find(strcmp(upper(ticktype),ttypes));
        if isempty(j)
          error('datafeed:bloomberg:invalidTickType','Invalid tick type requested: %s',ticktype)
        end
        ticktype = j;
      end
    
      %Request using bars
      [d,tikdate] = bbdatafeed(bbflag,reqval,c.connection,s,offset,0,verboseflag,sectype,intval,yrval,mtval,dyval,wkday,yrday,ticktype);
      d = [unique(tikdate) d'];
      
      %Convert times in seconds to MATLAB date numbers
      if ~isempty(d)
        d(:,1) = ticktime2datenum(d(:,1));
      end
      
      if offset > 50
        error('datafeed:bloomberg:expiredDate','Security not in tickdb.  Data date is not within last 50 trading days.') 
      end
      return
      
    else
        
      %Request raw tick data
      [d,tikdate] = bbdatafeed(bbflag,reqval,c.connection,s,offset,0,verboseflag,sectype,intval,0,0,0,0,0,0);
      
      if tikdate == 0
        warning('datafeed:bloomberg:expiredDate','Returned tick date does not match user specified date.') 
      end
      
    end 
    
    %Convert time stamps to MATLAB date numbers
    if size(d,2) > 1
      hrs = (d(:,2)/3600)/24;   %3600 seconds in an hour, 24 hours in a day
      d(:,2) = hrs;
    end
    
    %Add date stamps to time stamps
    y = floor(tikdate/10000);
    m = floor(tikdate/100) - y*100;
    dy = tikdate - y*10000 - m*100;
    d(:,2) = d(:,2) + datenum(y,m,dy);
    
    %Replace invalid data with NaN's
    j = find(d < 1e-9);
    d(j) = NaN;
    
  case 6  %TICKER LOOKUP
    
    %Get verbose bbdatafeed output flag
    verboseflag = parseverboseflag(2,varargin);
    
    %Get lookup data, verboseflag is 7th input, pad with zero
    d = bbdatafeed(bbflag,reqval,c.connection,s,varargin{1},0,verboseflag);
    
  case 7  %SECURITY MONITOR
  
    %maximum number of securities is 10
    maxsec = 10;
    if length(s) > maxsec
      error('datafeed:bloomberg:maxInputs','Maximum number of securities for MONITOR call is %d.',maxsec);
    end
    
    %Get monitor API command
    apicom = varargin{1};
    if iscell(apicom)
      apicom = apicom{:};
    end
    
    %Get number of ticks for call to timeout automatically
    if length(varargin) > 1
      numticks = varargin{2};
    else
      numticks = 0;
    end
    
    %Get verbose bbdatafeed output flag
    verboseflag = parseverboseflag(3,varargin);
   
    %Start monitoring security
    try
      fetch(c,'N/A','CLEAR');  %clear any previous requests on connection
      d = bbmonitor(1,c.connection,s,apicom,numticks,verboseflag,length(s),sectype);  
    catch
      %Trap error, clear connection of requests, display error
      [msgid,message] = lasterr;
      fetch(c,'N/A','CLEAR');
      error(msgid,message)
    end
    
    %Convert dates and times to MATLAB date numbers
    d = bbdatetime2mldatenum(d);
    
  case 8 %CLEAR for given connection
        
    bbmonitor(2,c.connection,{'NA'},'NA',0,0,0,0);      

end

%SUBFUNCTIONS

function x = parseverboseflag(n,varargin)
%PARSEVERBOSEFLAG Get verboseflag from variable length input.

if length(varargin{:}) < n, x = 0; else, x = varargin{1}{n}; end

function [fids,f,ftypes] = getfieldids(x,varargin)
%GETFIELDIDS Convert fieldnames into fieldids.

%Make field information so it is only loaded once
global bbcategories bbfieldids bbfieldnames upperbbfieldnames bbfieldtypes
    
%Load field information if not already loaded
if isempty(bbcategories) | isempty(bbfieldids) | isempty(bbfieldnames) | isempty(upperbbfieldnames) | isempty(bbfieldtypes)
  load @bloomberg/bbfields
  upperbbfieldnames = upper(bbfieldnames);
end
    
%Fields list should be cell array string
if ischar(varargin{1}{x}), f = cellstr(varargin{1}{x}); else, f = varargin{1}{x}; end
if ~ischar(f{1}), error('datafeed:bloomberg:fieldInputError','Field list must be cell array of strings.'), end
  
%Convert fieldnames to field ids
for i = 1:length(f)
  j = find(strcmp(upper(f{i}),upperbbfieldnames));
  if isempty(j)
    error('datafeed:bloomberg:invalidField','Invalid field - %s',f{i})
  elseif length(j) > 1
    j = j(1);
  end
  fids(i) = bbfieldids(j);
  ftypes(i) = bbfieldtypes(j);
end

function x = ovval2ovstr(varargin)
%OVVAL2OVSTR Override values to cell array of strings.

numin = length(varargin{:});

switch numin
   
  case 1   %Missing override values
    
    error('datafeed:bloomberg:missingOverrideValue','No override values given for override fields.')
    
  otherwise
    
    %Convert override values to cell array if necessary
    cls = class(varargin{1}{2});
    switch cls
      case 'cell'
        ovrs = varargin{1}{2};
      case 'char'
        ovrs = cellstr(varargin{1}{2});
      otherwise
        ovrs = num2cell(varargin{1}{2});
    end
          
    %Test for equal number of override fields and values
    numflds = length(varargin{1}{1});
    numvals = length(ovrs);
    if numflds ~= numvals
      error('datafeed:bloomberg:missingOverrideValue','Each override field must have a corresponding override value.')
    end
      
    %Preallocate output
    x = cell(numvals,1);
    for i = 1:numvals
      x{i} = num2str(ovrs{i});
    end
       
end


function mld = bbdatetime2mldatenum(d)
%BBDATETIME2MLDATENUM Converts Bloomberg date and time values to MATLAB date numbers.

%Get the fieldnames of structure, looking for Date and Time strings
flds = fieldnames(d);

%Convert dates to date numbers and times to date fractions
for i = 1:length(flds)
  if ~isempty(findstr('Date',flds{i})) & isempty(findstr('ToDate',flds{i}))
    try
      eval(['tmp = d.' flds{i} ';'])
      yr = round(tmp/10000);
      mt = round(tmp/100) - yr*100;
      dy = round(mod(tmp/100,1) * 100);
      eval(['d.' flds{i} ' = datenum(yr,mt,dy);'])
    catch
    end
  elseif ~isempty(findstr('Time',flds{i}))
    try
      eval(['d.' flds{i} ' = d.' flds{i} '/3600/24;'])
    catch
    end
  elseif (strcmp(flds{i},'SecurityKey'))
    %do nothing to security key
  else
    eval(['tmp = d.' flds{i} ';'])
    if ~iscell(tmp) && ~ischar(tmp)
      j = find(tmp < -1e9);   %Bloomberg returns invalid data as negative number, convert to NaN
      tmp(j) = NaN;
      eval(['d.' flds{i} ' = tmp;'])
    end
  end
end

mld = d;

function x = findoperator(s)
%FINDOPERATOR True if any mathematical operators in string.
%   X = FINDOPERATOR(S) returns 1 if any of ':/+*^' are found in the input
%   string.  No + or - as first character some strings could represent pos/neg numbers.

x = 0;
if findstr(':',s),x = 1;end
if findstr('/',s),x = 1;end
i = findstr('+',s);
if (~isempty(i) & (length(i) > 1 | any(i ~= 1))), x = 1;end
if findstr('*',s),x = 1;end 
if findstr('^',s),x = 1;end
i = findstr('-',s);
if (~isempty(i) & (length(i) > 1 | any(i ~= 1))), x = 1;end

function x = parsestring(s)
%PARSESTRING Return bulk data fields as cell array

%Semicolon is delimiter
k = findstr(';',s);
if isempty(k)
  y = s;
else
  y = cell(length(k),1);
  j = 1;
  while ~isempty(s)
    [y{j},s] = strtok(s,';');
    j = j+1;
  end
end

%Output data in array of given dimensions
if ischar(y) || ~iscell(y) || isempty(y)
  x{1} = y;
else
  x = cell(str2double(y{3}),str2double(y{2}));
  x(:) = y(5:2:end);
  x = x';
end

function y = ticktime2datenum(x)
%TICKTIME2DATENUM Tick time to MATLAB date number.
%   Y = TICKTIME2DATENUM(X) converts tick time, YYYYMMDDHHMMSS, to MATLAB date numbers.
%   X is the vector of tick times.  

s = mod(x,100) * 100;    %seconds
mi = floor(mod(x,10000)/100);  %minutes
h = floor(mod(x,1000000)/10000); %hours
d = floor(mod(x,100000000)/1000000); %days
mo = floor(mod(x,10000000000)/100000000); %months
yr = floor(mod(x,100000000000000)/10000000000); %years

y = datenum(yr,mo,d,h,mi,s);
