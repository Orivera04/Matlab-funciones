function TargetDate = datemnth(StartDate, NumberMonths, DayFlag, Basis,...
     EndMonthRule) 
%DATEMNTH Future or Past Date Given a Number of Months Movement Forward
%    or Backward in Time
%
%   TargetDate = datemnth(StartDate, NumberMonths, DayFlag,...
%        Basis, EndMonthRule)
%
%   Summary: This function determines the serial date number for a date in a
%            future or past month based on movement either forward or backward
%            in time by a given number of months.
%
%   Inputs: 
%     StartDate - Nx1 or 1xN vector containing values for the start date
%       in either serial date number or date string form
%     NumberMonths - Nx1 or 1xN vector containing values for the number
%       months movement forward or backward in time; values must be in
%       integer form
%     DayFlag - Nx1 or 1xN vector containing values which specify how the
%       actual day number for the target date in future or past month
%       is determined; possible values are:
%       a) DayFlag = 0 (default) - day number should be the day in the
%             future or past month corresponding to the actual day
%             number of the start date
%       b) DayFlag = 1 - day number should be the first day of the
%             future or past month
%       c) DayFlag = 2 - day number should be the last day of the
%             future or past month
%     Basis - Nx1 or 1xN vector or scalar value specifying the basis to
%       be used when determining the past or future date;
%       possible values are:
%       1) Basis = 0 - actual/actual(default)
%       2) Basis = 1 - 30/360
%       3) Basis = 2 - actual/360
%       4) Basis = 3 - actual/365
%     EndMonthRule - Nx1 or 1xN vector or scalar value specifying
%       whether or not the "end of month rule" is in effect:
%       1) EndMonthRule = 1 - rule is in effect (meaning that if you
%             are beginning on the last day of a month, and the month
%             has 30 or fewer days, you will land on the last actual
%             day of the future or past month regardless of whether
%             that month has 28, 29, 30 or 31 days)
%       2) EndMonthRule = 0 (default) - rule is NOT in effect
%
%   Outputs: 
%     TargetDate - Nx1 or 1xN vector containing the serial date number
%     of the target date in the future or past month
%
%   Example: 
%     StartDate = '03-Jun-1997';
%     NumberMonths = 6;
%     DayFlag = 0;
%     Basis = 0;
%     EndMonthRule = 1;
%
%     TargetDate = datemnth(StartDate, NumberMonths, DayFlag,...
%          Basis, EndMonthRule)
%
%     returns:
%
%     TargetDate = 729727 (03-Dec-1997)
%
%   See also DAYS360, DAYS365, DAYSACT, DAYSDIF, WRKDYDIF.

%Author(s): C. Bassignani, 10-17-1997
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.16 $   $Date: 2002/04/14 21:51:42 $ 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check the number of arguments passed in
%Check whether a value for the "end of month rule" flag was passed is; if not make sure
%it is set to the default "off" position
if (nargin < 5)
     EndMonthRule = 0;
end

%Check if basis argument is passed in; if not set to 0 (actual/actual)
if (nargin < 4 )
     Basis = 0; 
end

%Check to see if day flag switch is passed in; if not make sure
%it is set to the "off" (0) position
if (nargin < 3)
     DayFlag = 0;
end 


%If less than two arguments are passed in and then return an error
if (nargin < 2)
  error('Please enter data for at least the start date and the number of months!') 
end

if (isstr(StartDate)) 
  StartDate = datenum(StartDate); 
end

if (isstr(NumberMonths))
     NumberMonths = str2double(NumberMonths);
end


%Values for number of months must be integers
NumberMonths = round(NumberMonths);

if (isstr(DayFlag))
     DayFlag = str2double(DayFlag);
end


%Parse the day flag
IsDayFlag = find(DayFlag ~= 0 & DayFlag ~= 1 & DayFlag ~= 2);
if ~isempty(IsDayFlag)
   error('Invalid day flag specified!')
end


%Parse the basis argument
if (isstr(Basis))
     Basis = str2double(Basis);
end

IsBasis = find(Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3);
if ~isempty(IsBasis)
   error('Invalid bond basis specified!')
end


%Parse the end of month rule
if (isstr(EndMonthRule))
     EndMonthRule = str2double(EndMonthRule);
end

IsEndMonthRule = find(EndMonthRule ~= 0 & EndMonthRule ~=1);
if (~isempty(IsEndMonthRule))
     error('Invalid flag for end of month rule specified!')
end


%Do scalar expansion of input arguments as needed

%Scale up input arguments as required
sz = [size(StartDate); size(NumberMonths); size(DayFlag); size(Basis);...
          size(EndMonthRule)]; 
if length(StartDate) == 1 
     StartDate = StartDate*ones(max(sz(:,1)),max(sz(:,2))); 
end

if length(NumberMonths) == 1 
     NumberMonths = NumberMonths*ones(max(sz(:,1)),max(sz(:,2))); 
end

if length(DayFlag) == 1 
     DayFlag = DayFlag*ones(max(sz(:,1)),max(sz(:,2))); 
end 

if length(Basis) == 1 
  Basis = Basis*ones(max(sz(:,1)),max(sz(:,2))); 
end 

if length(EndMonthRule) == 1 
  EndMonthRule = EndMonthRule*ones(max(sz(:,1)),max(sz(:,2))); 
end 


%Make sure the "size" consistency among all the input arguments is now the same
%If it is not, return an error
if checksiz([size(StartDate); size(NumberMonths); size(DayFlag); size(Basis);...
          size(EndMonthRule)], mfilename)
     return
end 


%Get the size of the inputs for reshaping the output
[RowSize, ColumnSize] = size(StartDate); 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%All inputs should be in column vectors for processing
StartDate = StartDate(:);
NumberMonths = NumberMonths(:);
DayFlag = DayFlag(:);
Basis = Basis(:);
EndMonthRule = EndMonthRule(:);

%Get all necessary components of date vectors
StartVec = datevec(StartDate(:)); 
YearNumber = StartVec(:, 1);
MonthNumber = StartVec(:, 2);
StartMonthNumber = StartVec(:, 2);
StartDayNumber = StartVec(:, 3);
EndDayNumber = StartDayNumber;


%Get the last actual days of all start months
LastActStartDay = eomday(YearNumber, MonthNumber);


%Move ahead (or back) and find the number of the month preceeding
%the target month    
JuxtMonth = rem(MonthNumber + NumberMonths(:) - 1,12);


%Increment year if necessary
YearNumber = YearNumber + floor((MonthNumber + NumberMonths(:) - 1)/12);


%Set output month number; month number must be between 1 and 12
MonthNumber = rem(JuxtMonth + 12, 12) + 1;


%Get the last actual days for all months in which resulting dates fall
LastActDay = eomday(YearNumber, MonthNumber);
Ind = find(MonthNumber == 2 & LastActDay > 28 & Basis == 3);
if ~isempty(Ind)
	LastActDay(Ind) = 28;
end

Ind = find(EndDayNumber > LastActDay);
if ~isempty(Ind)
	EndDayNumber(Ind) = LastActDay(Ind);
end

Ind = find(MonthNumber == 2 & EndDayNumber > 28 & Basis == 3);
if ~isempty(Ind)
	EndDayNumber(Ind) = 28;
end


%Find cases where DayFlag is set to "1"
DF1 = find(DayFlag == 1);
if (~isempty(DF1))
  %Convert DayNumber to 1st
 EndDayNumber(DF1) = 1;
end


%Find cases where DayFlag is set to "2"
DF2 = find(DayFlag == 2);
if (~isempty(DF2))
  %Convert DayNumber to last actual day
 EndDayNumber(DF2) = LastActDay(DF2);
end


%Cases where Basis is 30/360
if (any(Basis == 1))      
     %For all those DayNumbers greater than 30, make them the 30th
     B1G30 = find(Basis == 1 & EndDayNumber > 30);
     if (~isempty(B1G30))
     	EndDayNumber(B1G30) = 30;
     end
end


%Cases where "end of month rule" is in effect
if (any(EndMonthRule))
     %Find cases where day number was last actual day of start month and make sure it is last
     %actual day of end month
     BEOM = find(StartDayNumber == LastActStartDay & EndMonthRule);
     if (~isempty(BEOM))
          EndDayNumber(BEOM) = LastActDay(BEOM);
     end
end


TargetDate = reshape(datenum(YearNumber(:), MonthNumber(:), EndDayNumber(:)), RowSize,...
     ColumnSize);

