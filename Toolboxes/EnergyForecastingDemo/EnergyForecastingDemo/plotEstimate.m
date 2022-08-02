function h = plotEstimate(allMonthData, dayType, reqDays, reqHours, config)

% Parse the data for the days of interest

   data          = filterDays(allMonthData, dayType, reqDays);

% Find the number of days and hours in the data

  [numDays, numHours] = size(data) ;

% Store data as a function of 'day of month' and 'hour of day'

   dataByDay     =  data';
   dataByHour    =  data ;

% Create vectors of days and hours

   days          =  1:numDays  ;
   hours         =  1:numHours ;

% Compute Basic Statistics

   meanByDay     = mean(dataByDay , 1   ) ;% average all days
   stdByDay      = std (dataByDay , 0, 1) ;% standard deviation (all days)

   meanByHour    = mean(dataByHour, 1   ) ;% average all hours
   stdByHour     = std (dataByHour, 0, 1) ;% standard deviation (all hours)

% Plot the raw data from the chosen days

   plot (hours, dataByHour, 'Color', [0.8 0.8 0.8]      );%plot raw data 

% Compute y-vectors for the +/- 1,2,&3 standard deviation regions

   yp3    = [ meanByHour + 3*stdByHour ]      ;%plus  3 std
   yp2    = [ meanByHour + 2*stdByHour ]      ;%plus  2 std
   yp1    = [ meanByHour +   stdByHour ]      ;%plus  1 std
   ym1    = [ meanByHour -   stdByHour ]      ;%minus 1 std
   ym2    = [ meanByHour - 2*stdByHour ]      ;%minus 2 std
   ym3    = [ meanByHour - 3*stdByHour ]      ;%minus 3 std

h = [];
   
if nargin == 5
  
% Plot the 3 standard deviation region as a patch, hide if requested

   h(3) =patch([hours, hours(end:-1:1)] , ...
               [  ym3,   yp3(end:-1:1)] , ...
               [1.0 0.85 0.80]                 );%confidence region
   if(~config.std_thr)
      set(h(3), 'Visible', 'off');
   end

% Plot the 2 standard deviation region as a patch, hide if requested

   h(2) =patch([hours, hours(end:-1:1)] , ...
               [  ym2,   yp2(end:-1:1)] , ...
               [1.0 0.65 0.71]                 );%confidence region
   if(~config.std_two)
      set(h(2), 'Visible', 'off');
   end

% Plot the 1 standard deviation region as a patch, hide if requested

   h(1) =patch([hours, hours(end:-1:1)] , ...
               [  ym1,   yp1(end:-1:1)] , ...
               [1.0 0.48 0.58]                 );%confidence region
   if(~config.std_one)
      set(h(1), 'Visible', 'off');
   end

end

% Plot the mean as a line

   line (hours, meanByHour, 'LineWidth', 2, 'Color', 'k');%plot mean

% Record the mean and standard deviation for chosen times in a legend

   timeLegend(reqHours, meanByHour, stdByHour);

% Pretty up the figure

   xlabel('Hour of Day'              ); 
   ylabel('System Load (MW)'         );
   title ('Daily Profile (mean & CI)');
   grid  ('on');

   xlim  ([ 1  24]                   );
   ylim  ([25 120]                   );
   set   (gca, 'xtick', [ 1 3 6 9 12 15 18 21 24 ]);

% Display the data as a function of day of month

% subplot(1,2,2);

% plot (days , dataByDay , 'Color', [0.8 0.8 0.8]      );%plot raw data
% patch([days         ,          days(end:-1:1)], ...
%       [ciByDayLower ,  ciByDayUpper(end:-1:1)], ...
%       [0.8 0.8 0.8]                                  );%confidence region
% line (days , meanByDay , 'LineWidth', 2, 'Color', 'r');%plot mean

% xlabel('Day of Month'               ); 
% ylabel('System Load (MW)'           );
% title ('Monthly Profile (mean & CI)');
% grid  ('on');

% xlim  ([1 31]);
% set   (gca, 'xtick', [ 1 8 15 22 29 31]);

%---------------------------------------------------------------------------
%
%---------------------------------------------------------------------------
function data = filterDays(allData, daysOfWeek, reqDaysOfWeek);

% Sort the days by they daysOfWeek in Month (find all Mondays, Tuesdays, etc.)

   MON           = find(daysOfWeek == 1)' ;%Find all the Mondays
   TUE           = find(daysOfWeek == 2)' ;%Find all the Tuesdays
   WED           = find(daysOfWeek == 3)' ;%Find all the Wednesdays
   THU           = find(daysOfWeek == 4)' ;%Find all the Thursdays
   FRI           = find(daysOfWeek == 5)' ;%Find all the Fridays
   SAT           = find(daysOfWeek == 6)' ;%Find all the Saturdays
   SUN           = find(daysOfWeek == 7)' ;%Find all the Sundays
   HOL           = find(daysOfWeek == 8)' ;%Find all the Holidays

% Convert requested days of week into days in the month

   reqDaysOfMonth = [];%initialize to empty set

   for n = 1:length(reqDaysOfWeek)
      switch lower(reqDaysOfWeek{n})
         case 'monday'
            reqDaysOfMonth = [ reqDaysOfMonth, MON ];
         case 'tuesday'
            reqDaysOfMonth = [ reqDaysOfMonth, TUE ];
         case 'wednesday'
            reqDaysOfMonth = [ reqDaysOfMonth, WED ];
         case 'thursday'
            reqDaysOfMonth = [ reqDaysOfMonth, THU ];
         case 'friday'
            reqDaysOfMonth = [ reqDaysOfMonth, FRI ];
         case 'saturday'
            reqDaysOfMonth = [ reqDaysOfMonth, SAT ];
         case 'sunday'
            reqDaysOfMonth = [ reqDaysOfMonth, SUN ];
         case 'holiday'
            reqDaysOfMonth = [ reqDaysOfMonth, HOL ];
         case 'weekday'
            reqDaysOfMonth = [ reqDaysOfMonth, MON, TUE, WED, THU, FRI ];
         case 'weekend'
            reqDaysOfMonth = [ reqDaysOfMonth, SAT, SUN, HOL ];
         case 'all'
            reqDaysOfMonth =   1:length(daysOfWeek) ;%all days
         otherwise
            error([ reqDays{n} ' is not a valid Day of Week']);
      end
   end

   reqDaysOfMonth = unique(sort(reqDaysOfMonth)) ;%Sort and remove duplicates

% Return only the requested days of the month

   data = allData(reqDaysOfMonth,:);

%---------------------------------------------------------------------------
%
%---------------------------------------------------------------------------
function timeLegend(theHours, theMeans, theStds)

% Define marker colors and symbols

  colors  = { 'blue'   , 'green'  , 'red'    ,            ...
              'cyan'   , 'magenta', 'yellow' , 'black'  , ...
              'blue'   , 'green'  , 'red'    ,            ...
              'cyan'   , 'magenta', 'yellow' , 'black'  , ...
              'blue'   , 'green'  , 'red'    ,            ...
              'cyan'   , 'magenta', 'yellow' , 'black'  , ...
              'blue'   , 'green'  , 'red'    ,            ...
              'cyan'   , 'magenta', 'yellow' , 'black'  };

  symbols = { 'o'      , 'o'      , 'o'      ,            ...
              'o'      , 'o'      , 'o'      , 'o'      , ...
              's'      , 's'      , 's'      ,            ...
              's'      , 's'      , 's'      , 's'      , ...
              '^'      , '^'      , '^'      ,            ...
              '^'      , '^'      , '^'      , '^'      , ...
              '*'      , '*'      , '*'      ,            ...
              '*'      , '*'      , '*'      , '*'      };

% Plot a marker at the requested times

  for n = 1:length(theHours)
     thisHour = theHours(n)       ;
     thisMean = theMeans(thisHour);
     thisStd  = theStds (thisHour);
     h(n)     = line(thisHour, thisMean  , ...
                     'Marker'         , symbols{n}, ...
                     'MarkerFaceColor', colors{n} , ...
                     'Color'          , colors{n}         );
     leg{n}   = sprintf('%s %2d %s %5.2f %s %5.2f', ...
                        'T:'     , thisHour, ...
                        '\mu:'   , thisMean, ...
                        '\sigma:', thisStd       );
  end

  legend(h, leg);

