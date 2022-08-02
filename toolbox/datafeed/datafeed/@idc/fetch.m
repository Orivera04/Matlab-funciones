function d = fetch(c,s,f,varargin)
%FETCH Request data from IDC data server.
%   D = FETCH(C,S,F) returns the data for the fields F for the 
%   security list, S.   Load the file idc/idcfields to see the list of 
%   supported fields.
%
%   D = FETCH(C,S,F,FROMDATE,TODATE) returns the historical data for 
%   the fields, F, for the dates FROMDATE to TODATE.
%
%   D = FETCH(C,S,F,FROMDATE,TODATE,PER) returns the historical data for 
%   the fields, F, for the dates FROMDATE to TODATE with the periodicity, PER.  
%   Please refer to Remote Plus documentation for valid PER values.
%
%   D = FETCH(C,S,'Lookup',TYP,MARKET,N,M) returns look up data for the 
%   search string, S, the look up type, TYP, (F for fields, S for securities), 
%   the market, MARKET.  The look up option returns N records starting at 
%   record M.
%
%   For example, D = FETCH(C,'Ford','Lookup','S','Equity',4,1) returns the
%   first 4 securities containing the string 'Ford' starting the 1st record.
%
%   D = FETCH(C,'','Lookup','S') returns all valid security categories.
%   D = FETCH(C,'','Lookup','F') returns all valid field categories.
%
%   D = FETCH(C,'','GUILOOKUP','S') opens the IDC dialog for looking up securities.
%   D = FETCH(C,'','GUILOOKUP','F') opens the IDC dialog for selecting fields.
%
%   See also IDC, CLOSE, ISCONNECTION.

%   Author(s): C.F.Garvin, 12-08-99
%   Copyright 1999-2003 The MathWorks, Inc.
%   $Revision: 1.10.2.2 $   $Date: 2004/04/06 01:06:04 $

%Security and field lists are required inputs
if nargin < 3
  error('datafeed:idc:inputError','Please input security and field list for data retrieval.')
end

%Validate security list.  Security list should be cell array string
if ischar(s)   
  s = cellstr(s);
end
if ~iscell(s) | ~ischar(s{1})
  error('datafeed:idc:securityInputError','Security list must be cell array of strings.')
end

%Add support for data retrieval flag for consistency among data providers
%Trap data retrieval and index into varargin to get fields and additional arguments
%for case where third input is not field list
if ischar(f)
  switch upper(f)
    
    case {'GETDATA','HISTORY'}
      dataflag = 1;
      
    case 'LOOKUP'
      
      %Lookup data
      
      %Lookup type if first argument of varargin
      L1 = length(varargin);
      if L1 < 3
        varargin{3} = 9999;    %Get all possible return data
      end
      L2 = length(varargin);
      t = varargin{1};
      switch upper(t)
        
        case 'F'   %Field lookup
          
          if L1 < 2
            typ = 'ICAT';   %Return all field categories
          else
            typ = 'ITM';    %Specific category requested
          end
          
        case 'S'   %Security lookup
          
          if L1 < 2
            typ = 'ECAT';    %Return all security categories
          else
            typ = 'ENT';     %Search in specific category
          end
          
        otherwise
          
          error('datafeed:idc:lookupError','Lookup type must be ''F'' for fields or ''S'' securities.')
          
      end
        
      %Build idc string
      idcstr = ['NAM,' typ];
      j = 0;   %Need counter so varargin element is not skipped after appending search string
      for i = 2:L2+1
        if i == 3
          idcstr = [idcstr ',' s{1}];  %Search string is in S argument
          j = 1;                       %Used so element of varargin is not skipped
        else
          if (i-j) > 2    %Varargin after 2nd element are numeric
            idcstr = [idcstr ',' num2str(varargin{i-j})];
          else
            idcstr = [idcstr ',' varargin{i-j}];
          end
        end
      end
      
      %Execute IDC command
      d = idcdatafeed(3,idcstr);
      
      %Remove empty elements
      [m,n] = size(d);
      j = [];
      for i = 1:m
        if isempty(d{i})
          j = [j;i];
        end
      end
      
      d(j,:) = [];
      
      return
      
    case 'GUILOOKUP'
      
      %Use IDC's dialog for looking up data
      t = varargin{1};
      switch upper(t)
        case 'F'
          typ = 'ITM';
        case 'S'
          typ = 'ENT';
        otherwise
          error('datafeed:idcgui:lookupError','Lookup type must be ''F'' for fields or ''S'' securities.')
      end
      
      %Open dialog
      d = idcdatafeed(5,['NSW,' typ]);
      
      return
        
    otherwise
      dataflag = 0;
  end
else
  dataflag = 0;
end  

%data retrieval flag entered, field list is first element of varargin
if dataflag
  f = varargin{1};
end

%Validate field list.  field list should be cell array string
if ischar(f)   
  f = cellstr(f);
end
if ~iscell(f) | ~ischar(f{1})
  error('datafeed:idc:fieldInputError','Field list must be cell array of strings.')
end

%Build security and field portion of command, all commands start with 'get,(
req = 'get,(';

%Build command with security and field information

%Parse security list
sec = [];
for i = 1:length(s)
  sec = [sec  s{i} ','];
end
%Strip off last comma and add closing paren, comma, and open paren for field list
l = length(sec);
sec(l) = [];
sec = [sec '),('];

%Parse field list
fld = [];
for i = 1:length(f)
  fld = [fld f{i} ','];
end
l = length(fld);
fld(l) = [];
fld = [fld ')'];

%Current request command (securities and fields only)
req = [req sec fld];

%Determine which form of get command to use based on number of inputs
numinp = length(varargin)-dataflag;

%Need number of securities and fields to determine size of ouput arrat
numsec = length(s);
numfld = length(f);

%Data request flag to IDCDATAFEED is 2
flg = 2;

%Determine which form of idcdatafeed to call
switch numinp
  
  case 0
  
    %No additional input arguments, get current data for given security and
    %field list
    d = idcdatafeed(flg,req,numsec,numfld);
  
  case {1,2,3}
  
    %Dates given, return data for dates
    
    %Validate date
    sdate = validdate(varargin{1+dataflag},'start');
    
    %Add start date to command
    req = [req ',' sdate];
    
    switch numinp
      
      case 1
      
        %Single date given
        d = idcdatafeed(flg,req,numsec,numfld);
        
      case 2
        
        %Date range 
        
        %Validate date
        edate = validdate(varargin{2+dataflag},'end');
        
        %Add end date to command
        req = [req ',' edate];
        
        %Retrieve data
        d = idcdatafeed(flg,req,numsec,numfld);
        
      case 3
        
        %Date range with periodicity
        
        %Validate date
        edate = validdate(varargin{2+dataflag},'end');
        
        %Add periodicity to command
        req = [req ',' edate ',' varargin{3+dataflag}];
        
        %Retrieve data
        d = idcdatafeed(flg,req,numsec,numfld);
        
    end
      
  otherwise
    
    error('datafeed:idc:inputError','Too many input arguments, please see IDC/FETCH help.')
    
end


%%Subfunctions

function s = validdate(d,t)
%VALIDDATE Validates given date, D, and returns as date string.
%   S = VALIDDATE(D,T) validates the given date, D, and returns it as 
%   date string of the form MM/DD/YY.   T is 'start' or 'end' 
%   depending on whether date is start or end of range.

try
  s = datestr(d);
  if isempty(s)
    error('datafeed:idc:dateError','Invalid date')
  end
catch
  error('datafeed:idc:dateError','Invalid %s date.',t)
end
