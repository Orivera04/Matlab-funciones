function dateaxis(aksis,dateform,startdate) 
%DATEAXIS Date axis labels. 
%	DATEAXIS(AKSIS,DATEFORM,STARTDATE) replaces axis tick labels with date 
%	labels.  AKSIS determines which axis tick labels, X, Y, or Z, should be
%	converted.  The default AKSIS argument is 'x'.  DATEFORM specifies which
%	date format to use.  If no DATEFORM argument is entered, this function 
%	determines the date format based on the span of the axis limits. 
%	For example, if the difference between the axis minimum and maximum  is
%	less than 15, the tick labels will be converted to 3 letter day of the
%	week abbreviations.  STARTDATE determines which date should be assigned to
%	the first axis tick value.  The tick values are treated as serial date
%	numbers.  The default STARTDATE is the lower axis limit converted to the
%	appropriate date value.  For example, a tick value of 1 is converted to
%	the date 01-Jan-0000.  By entering STARTDATE as '06-Apr-1995', the first
%	tick value is assigned the date April 6, 1995 and the axis tick labels
%	will be set accordingly. 
%      
%       DATEFORM    Format                Description 
% 
%          0        01-Mar-1995 15:45:17  (day-month-year, hour:minute) 
%          1        01-Mar-1995           (day-month-year) 
%          2        03/01/95              (month/day/year) 
%          3        Mar                   (month, three letter) 
%          4        M                     (month, single letter) 
%          5        3                     (month) 
%          6        03/01                 (month/day) 
%          7        1                     (day of month) 
%          8        Wed                   (day of week, three letter) 
%          9        W                     (day of week, single letter) 
%          10       1995                  (year, four digit) 
%          11       95                    (year, two digit) 
%          12       Mar95                 (month year) 
%          13       15:45:17              (hour:minute:second) 
%          14       03:45:17              (hour:minute:second AM or PM) 
%          15       15:45                 (hour:minute) 
%          16       03:45 PM              (hour:minute AM or PM) 
%          17       95/03/01              (year/month/day) 
% 
%	DATEAXIS('X') or DATEAXIS converts the X-axis labels to an 
%	automatically determined date format. 
% 
%	DATEAXIS('Y',6) converts the Y-axis labels to the 
%	month/day format. 
%     
%	DATEAXIS('X',2,'03/03/1995') converts the X-axis 
%	labels to the month/day/year format.  The minimum Xtick  
%	value is treated as March 3, 1995. 
 
%	Author(s): C.F. Garvin, 4-03-95 
%	Copyright 1995-2002 The MathWorks, Inc. 
%	$Revision: 1.11 $   $Date: 2002/04/14 21:51:39 $ 
 
dstr = []; 
 
if nargin == 0 
  aksis = 'x'; 
  Lim = get(gca,[aksis,'lim']); 
  startdate = 0; 
elseif nargin == 1 
  Lim = get(gca,[aksis,'lim']); 
  startdate = 0; 
elseif nargin == 2   
  startdate = 0; 
elseif nargin == 3 
  Lim = get(gca,[aksis,'lim']); 
  startdate = datenum(startdate)-Lim(1); 
end 
 
if nargin < 2 
  % Determine range of data and choose appropriate label format 
  Cond = Lim(2)-Lim(1); 
 
  if Cond <= 14 % Range less than 15 days, day of week   
    dateform = 7;  
  elseif Cond > 14 & Cond <= 31 % Range less than 32 days, day of month 
    dateform = 6; 
  elseif Cond > 31 & Cond <= 180 % Range less than 181 days, month/day 
    dateform = 5; 
  elseif Cond > 180 & Cond <= 365  % Range less than 366 days, 3 letter month 
    dateform = 3; 
  elseif Cond > 365 & Cond <= 365*3 % Range less than 3 years, month year  
    dateform = 11; 
  else % Range greater than 3 years, 2 digit year 
    dateform = 10; 
  end 
end 
 
% Get axis tick values and add appropriate start date. 
Lim = get(gca,[aksis,'lim']); 
xl = get(gca,[aksis,'tick'])'+datenum(startdate); 
set(gca,[aksis,'tickmode'],'manual',[aksis,'limmode'],'manual') 
 
n = length(xl); 
 
% To guarantee that the day, month, and year strings have the 
% the same number of characters after the integer to string  
% conversion, add 100 to the day and month numbers and 10000 to 
% the year numbers for proper padding.  This also allows for 
% padding numbers with zeros.  For example, the first day of a  
% given month will be printed as 01 instead of 1.  The tick values 
% are converted into one long concatenated string by int2str. 
% Reshape matrix so each column is a single value plus the  
% appropriate padding number.  Transpose so each row is now this 
% single value and the needed columns can be extracted. 
 
[mnum,mstring] = month(xl); % Get month number and string from values 
ds = int2str(day(xl)+100); % Build day of month matrix 
ms = int2str(mnum+100); % Build month number matrix 
ys = int2str(abs(year(xl))+10000); % Build year matrix 
hs = int2str(hour(xl)+100); % Build hour matrix 
mins = int2str(minute(xl)+100); % Build minute matrix 
ss = int2str(second(xl)+100); % Build second matrix 
 
if dateform == 0 % Day-Month-Year Hour:Minute 
  delim1 = char(ones(n,1)*'-'); 
  delim2 = char(ones(n,1)*':'); 
  delim3 = char(ones(n,1)*' '); 
  dstr = [ds(:,2:3),delim1,mstring,delim2,ys(:,2:5),delim3,... 
          hs(:,2:3),delim2,mins(:,2:3),delim2,ss(:,2:3)]; 
elseif dateform == 1  % Day-Month-Year (01-Mar-1995) 
  delim = char(ones(n,1)*'-'); 
  dstr = [ds(:,2:3),delim,mstring,delim,ys(:,2:5)]; 
elseif dateform == 2 % Month/Day/Year (03/01/1995) 
  delim = char(ones(n,1)*'/'); 
  dstr = [ms(:,2:3),delim,ds(:,2:3),delim,ys(:,4:5)]; 
elseif dateform == 3 % 3 letter month (Mar) 
  dstr = mstring; 
elseif dateform == 4 % 1 letter month (M) 
  dstr = mstring(:,1); 
elseif dateform == 5 % month (number) 
  dstr = ms(:,2:3); 
elseif dateform == 6 % Month/Day (03/01) 
  delim = char(ones(n,1)*'/'); 
  dstr = [ms(:,2:3),delim,ds(:,2:3)]; 
elseif dateform == 7 % Day of month (01) 
  dstr = ds(:,2:3); 
elseif dateform == 8 % 3 letter day of week (Wed) 
  [d,s] = weekday(xl); 
  dstr = s; 
elseif dateform == 9 % 1 letter day of week (W) 
  [d,s] = weekday(xl); 
  dstr = s(:,1); 
elseif dateform == 10 % 4 digit year (1995) 
  dstr = ys(:,2:5); 
elseif dateform == 11 % 2 digit year (95) 
  dstr = ys(:,4:5); 
elseif dateform == 12 % Month year (Mar95) 
  dstr = [mstring,ys(:,4:5)]; 
elseif dateform == 13 % hour:minute:second 
  delim = char(ones(n,1)*':'); 
  dstr = [hs(:,2:3),delim,mins(:,2:3),delim,ss(:,2:3)]; 
elseif dateform == 14 
  delim = char(ones(n,1)*':'); 
  medpad = char(ones(n,1)*' AM'); 
  nhs = str2double(hs(:,2:3)); 
  i = find(nhs >= 12); 
  medpad(i,:) = char(ones(length(i),1)*' PM'); 
  nhs = 100 + nhs; 
  nhs(i) = nhs(i) - 12; 
  hs = reshape(num2str(nhs),3,n)'; 
  if strcmp(hs,'100') 
    hs = '112'; 
  end 
  dstr = [hs(:,2:3),delim,mins(:,2:3),delim,ss(:,2:3),medpad]; 
elseif dateform == 15 
  delim = char(ones(n,1)*':'); 
  dstr = [hs(:,2:3),delim,mins(:,2:3)]; 
elseif dateform == 16 
  delim = char(ones(n,1)*':'); 
  medpad = char(ones(n,1)*' AM'); 
  nhs = str2double(hs(:,2:3)); 
  i = find(nhs >= 12); 
  medpad(i,:) = char(ones(length(i),1)*' PM'); 
  nhs = 100 + nhs; 
  nhs(i) = nhs(i) - 12; 
  hs = reshape(num2str(nhs),3,n)'; 
  if strcmp(hs,'100') 
    hs = '112'; 
  end 
  dstr = [hs(:,2:3),delim,mins(:,2:3),medpad]; 
elseif dateform == 17 % Year/Month/Day  (ISO format)    
  delim = char(ones(n,1)*'/');
  dstr = [ys(:,2:5),delim,ms(:,2:3),delim,ds(:,2:3)];
end 
  
% Set axis tick labels 
set(gca,[aksis,'ticklabel'],dstr)
