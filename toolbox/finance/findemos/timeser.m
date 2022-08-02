function T = timeser(start,periods,hldays)
%TIMESER Converts XData of time series plot to correct date values.
%   T = TIMESER(START,PERIODS,HLDAYS) converts the XData of time series plots to
%   the appropriate date values.  The axis tick labels can then be converted to
%   date string labels of the desired format using the DATEAXIS command. START is
%   the initial or starting date of the time series.  PERIODS specifies the  
%   frequency of the data.
%
%            Data frequency         Periods setting
%
%               daily                      1 (default)
%               weekly                     2
%               monthly                    3
%               quarterly                  4
%               semi-annual                5
%               annual                     6
%
%   Saturdays and Sundays are removed from the XData vector as are any specified
%   HLDAYS.  HLDAYS represents any non-trading days except Saturdays or Sundays
%   that should be eliminated from the dates associated with the time series data.
%   HLDAYS can be set by editing this function and adding appropriate dates, by
%   defining the dates in a global variable named HLDAYS, or by inputting it as
%   the third argument.
%
%   TIMESER converts the XData to a date vector using today's date as the START 
%   date.  By default, HLDAYS is defined within the function TIMESER or else
%   globally by the user.
%
%   TIMESER(START) converts the XData to a date vector using START as the starting
%   date.  By default, the data is treated daily data (PERIODS = 1) and HLDAYS is
%   defined within the function TIMESER or else globally by the user.
%
%   TIMESER(START,PERIODS) converts the XData to a date vector using START as the
%   starting date and PERIODS as the frequency of the data. By default, HLDAYS is
%   defined within the function TIMESER or else globally by the user.
%       
%   TIMESER(START,PERIODS,HLDAYS) converts the XData to a date vector using START
%   as the starting date, PERIODS as the frequency of the data and HLDAYS as the
%   non-trading days information.
%
%   TRADDAYS = TIMESER(...) returns the date vector information to the MATLAB
%   workspace without altering the XData of the time series plot.
%
%   See also DATEAXIS.

%       Author(s): C.F. Garvin, 7-17-95
%       Copyright 1995-2001 The MathWorks, Inc.
%       $Revision: 1.8.4.1 $   $Date: 2004/04/06 01:07:07 $


if nargin < 3 & ~exist('hldays')   % Define hldays if necessary
  hldays = [...
            '06-sep-1993';...
            '25-nov-1993';...
            '24-dec-1993';...
            '31-dec-1993';...
            '21-feb-1994';...
            '08-apr-1994';... 
            '30-may-1994';...
            '04-jul-1994';...
            '05-sep-1994';...
            '24-nov-1994';...
            '26-dec-1994';...
            '02-jan-1995';...
            '20-feb-1995';...
            '07-apr-1995';...
            '29-may-1995';...
            '04-jul-1995';...
            '04-sep-1995';...
            '23-nov-1995';...
            '25-dec-1995';...
            '01-jan-1996';...
            '19-feb-1996';...
            '05-apr-1996';...
            '27-may-1996';...
            '04-jul-1996';...
            '09-sep-1996';...
            '21-nov-1996';...
            '25-dec-1996';...
            '01-jan-1997'];
end
if nargin < 2
  periods = 1;     % Define periodicity of data
end
if isstr(hldays)
  NonTradDays = datenum(hldays);  % Convert hldays to numeric if necessary
end

if nargin == 0                       % Default start date is today
  begin = today;
else
  begin = datenum(start);           % Make sure start is numeric
end

ChartType = getappdata(gca,'plottype');          % chart type tag, set by HighLow and Candle
if isempty(ChartType)
  ChartType = '       ';
end

if ChartType == 'HighLow'            % Determine number of points in time series
  ObjectFactor = 9;                  % # children/ObjectFactor = # data points
  Child = flipud(get(gca,'children'));
  NumPts = length(get(Child(1),'Xdata'))/ObjectFactor;
elseif ChartType == 'Candle '
  ObjectFactor = 3;
  Child = flipud(get(gca,'children'));
  NumPts = length(get(Child(1),'Xdata'))/ObjectFactor;  % Number of data points
else                                    % not a special chart type
  Child = flipud(get(gca,'children'));
  if isempty(Child)
    close
    error(sprintf('No figure currently open or no data on axes.'))
  end
  NumPts = length(get(Child(1),'Xdata')); 
end


if periods == 1                                 % daily data
  DateVectPad = NumPts+ceil(NumPts/2)+length(NonTradDays);%Date vect extension
  % Date vector must be long enough to account for all data points, hence
  % DateVectPad, NumPts/2 accounts for weekends being removed from vector
  AllDays = begin:(begin+DateVectPad); % Build date vector

  DOW = weekday(AllDays);                     % Find weekday numbers
  WDIndex = find(DOW ~= 1 & DOW ~= 7);        % Find weekend days
  WeekDays = AllDays(WDIndex);                % Eliminate weekends from vector

  [Hrow, Hcol] = size(WeekDays);
  aInd = find(NonTradDays > max(WeekDays)); %Find NonTradDays after WeekDays
  NonTradDays(aInd) = [];                   % Set these days to null
  bInd = find(NonTradDays < min(WeekDays)); %Find NonTradDays before WeekDays 
  NonTradDays(bInd) = [];                   % Set these days to null
  combin = sort([NonTradDays(:);WeekDays(:)]);% Find NonTradDays = WeekDays
  dc = diff(combin);
  z = find(dc==0);
  shift = 0:length(NonTradDays(:))-1;
  HolIndex = z-shift(:);
  WeekDays(HolIndex) = [];                    % Eliminate hldays from vector
  TradDays = WeekDays(1:NumPts);              % Get applicable trading days
elseif periods == 2                           % weekly data
  TradDays = begin:7:begin+(NumPts-1)*7;    
elseif periods == 3                           % monthly data
  TradDays = datemnth(begin*ones(NumPts,1),(0:NumPts-1)');
elseif periods == 4                           % quarterly data
  TradDays = datemnth(begin*ones(NumPts,1),(0:3:(NumPts-1)*3)');
elseif periods == 5                           % semi-annual data
  TradDays = datemnth(begin*ones(NumPts,1),(0:6:(NumPts-1)*6)');
elseif periods == 6                           % annual data
  TradDays = datemnth(begin*ones(NumPts,1),(0:12:(NumPts-1)*12)');
end

if nargout == 0                               % modify plot if no outputs
  if ChartType == 'HighLow'                   % Convert XData
    TD = TradDays(ones(1,3),:);
    X = get(Child(1),'Xdata');
    NewX = X(:)-round(X(:))+[TD(:);TD(:);TD(:)];
    set(Child(1),'Xdata',NewX)
  elseif ChartType == 'Candle '
    TD = TradDays(ones(1,3),:);
    X = get(Child(1),'Xdata');
    set(Child(1),'Xdata',TD(:));
    X = get(Child(2),'Xdata');
    I = round(X);
    set(Child(2),'Xdata',X-I+TradDays(I));
    X = get(Child(3),'Xdata');
    I = round(X);
    set(Child(3),'Xdata',X-I+TradDays(I));
  elseif ChartType == 'MovAver'
    set(Child(1:3),'Xdata',TradDays)               % Assign dates to data points
  elseif ChartType == 'Bolling'
    set(Child(1:4),'Xdata',TradDays)               % Assign dates to data points
  else
    set(Child,'Xdata',TradDays)
  end
end

if nargout == 1                               % return new XDat if queried
  T = TradDays;                               % without modifying plot
end
