function NumberDays = wrkdydif(Date1, Date2, NumberHolidays) 
%WRKDYDIF Number of Working Days between Dates 
%   NumberDays= WRKDYDIF(Date1, Date2, NumberHolidays)  
%
%   Summary: This function determines the number of working days between two
%            dates given a number of holidays.
%
%   Inputs: Date1 - Nx1 or 1xN vector containing the date string or serial date
%                   number for the start date
%           Date2 - Nx1 or 1xN vector containing the date string or serial date
%                   number for the end date
%           NumberHolidays - Nx1 or 1xN vector containing values for the number
%                   of days movement in terms of holidays into the future (if
%                   positive) or past (if negative)
%
%   Outputs: NumberDays - Nx1 or 1xN vector containing the number of days between
%            Date1 and Date2
%
%   Example: Date1 = '9/1/1995';
%            Date2 = '9/11/1995';
%            NumberHolidays = 1;
%
%            NumberDays = wrkdydif(Date1, Date2, NumberHolidays)
%
%            returns:
%
%            NumberDays = 6
% 
%   See also DATEWRKDY. 
  
%Author(s): C.F. Garvin, 2-23-95, C. Bassignani, 10-7-97
%       Copyright 1995-2002 The MathWorks, Inc.  
%$Revision: 1.10 $   $Date: 2002/04/14 21:51:12 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%              ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin < 1 )
     error('Please enter Date1!') 
end 

if (isstr(Date1)) 
     Date1 = datenum(Date1); 
end 

if nargin < 2
     Date2 = Date1;
     Date1 = today*ones(size(Date2));
else
     Date2 = datenum(Date2);
end

if nargin < 3
     NumberHolidays = zeros(size(Date1));
end

if any(NumberHolidays < 0)
     error('The number of holidays must be >=0.');
end

%Get the size of all input arguments; scale up any scalars
sz = [size(Date1); size(Date2); size(NumberHolidays)]; 

if (length(Date1) == 1)
     Date1 = Date1 * ones(max(sz(:,1)), max(sz(:,2))); 
end 

if (length(Date2) == 1)
     Date2 = Date2 * ones(max(sz(:,1)), max(sz(:,2))); 
end 

if (length(NumberHolidays) == 1)
     NumberHolidays = NumberHolidays * ones(max(sz(:,1)), max(sz(:,2))); 
end 


%Make sure all input arguments are of the same size and shape
if (checksiz([size(Date1); size(Date2); size(NumberHolidays)], mfilename))
     return
end


%Get the shape of the inputs to reshape output later
[RowSize, ColumnSize] = size(Date1);

Date1 = Date1(:);
Date2 = Date2(:);
NumberHolidays = NumberHolidays(:);
NumNumberDays = length(Date1);
NumberDays = zeros(NumNumberDays, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GENERATE OUTPUTS ***********
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Step = ones(size(Date1));

Ind = find(Date1 > Date2);
if (~isempty(Ind))
     Step(Ind) = -1;
end

for i = 1 : NumNumberDays
     DaysVec = Date1(i):Step(i):Date2(i);
     
     %Find weekday numbers
     DayNum = weekday(DaysVec);  
     
     %Remove Sat and Sun
     NumberDays(i) = length(find(DayNum ~= 1 & DayNum ~= 7)) - NumberHolidays(i);  
end 


%Build flag to change number of days between dates to negative in cases where Date1
%preceeds Date2
SignAdj = find(Date1 > Date2);
if (~isempty(SignAdj))
     NumberDays(SignAdj) = - NumberDays(SignAdj);
end


