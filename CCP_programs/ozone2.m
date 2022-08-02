%  ozone2.m
% Matlab file for Part 2 of the Warming, Cooling,
% and Urban Ozone Pollution module

disp('********************************************')
disp('Part 2:  The Cooling Curve')
disp('********************************************')
disp('  ')    

    format short

    disp('The time and temperature data have been ')
    disp('already entered into your workspace as ')
    disp('variables called ''''times'''' and ''''temps''''.')
    disp(' ')
    times=0:10:350;
    temps=[95.5,92.4,90.3,88.1,86.7,85.3,...
          84.2,83.2,81.9,80.8,80.0,79.2,...
          78.6,78.0,77.4,76.9,76.2,75.8,...
          75.4,75.1,74.7,74.4,74.2,73.9,...
          73.7,73.6,73.4,73.3,73.1,73.1,...
          73.0,72.9,72.8,72.7,72.7,72.6];
    disp('We show a scatter plot of the data')
    disp('pairs (times,temps), and hold it.')
    figure(1)
    clf
    plot(times,temps,'bo')
    xlabel('Times (seconds)')
    ylabel('Temperatures (F degrees)')
    title('The Cooling Curve')
    hold on
    disp(' ')
    disp('To continue, hit any key!')
    disp(' ')
    pause

    disp(' ')
    disp('--------------------------------------------')
    disp('We change the vertical plot scale by ')
    disp('subtracting 72.3 degrees from each temperature.')
    disp('The scaled temperatures are in variable ')
    disp('''''sctemps''''. ')
    disp(' ')
    disp('We make a new plot of the pairs (times,sctemps)')
    disp('in figure window 2. ')
    sctemps=temps-72.3;
    figure(2); clf
    plot(times,sctemps,'bo')
    xlabel('Times (seconds)')
    ylabel('Temperatures - 72.3 degrees')
    title('The Scaled Cooling Curve')
    disp(' ')
    disp('To continue, hit any key! ')
    disp(' ')
    pause

    disp(' ')
    disp('--------------------------------------------')
    disp('To make a semilog plot of our data, we will')
    disp('plot the pairs (times, log(sctemps)) in the')
    disp('figure 2 window. ')
    disp('Copy the following commands and paste them at')
    disp('a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  plot(times,log(sctemps),''g+'') ')
    disp('  xlabel(''time '')  ')
    disp('  ylabel(''log( scaled temperature )'')  ')
    disp('  title(''SemiLog Plot of Scaled Temps'') ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------') 
    disp('Find the decay constant k, the negative of the')
    disp('slope of the linear pattern of points in the')
    disp('semilog plot, and enter your k value into ')
    disp('MATLAB.  Note: k is a positive number.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Make sure your values of the ambient ')
    disp('temperature a, the initial temperature of the')
    disp('probe T0, and the decay constant k are')
    disp('entered into MATLAB.')
    disp(' ')
    a=72.3; T0=95.5;
    disp('----------------------------------------------')
    disp('Then, make a plot of the model function:')
    disp('     T = a + (T0-a)*exp(-k*t). ')
    disp('The figure window has been set so that it')
    disp('will appear on top of the scatter plot of')
    disp('the original (times,temps) data in figure 1.')
    figure(1)
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------')  
    disp('Step 6: ')
    disp('Entering the following commands will compute')
    disp('symmetric difference quotients to approximate')
    disp('the slope of the temperature curve at various')
    disp('times.  ')
    disp(' ')
    disp('Copy the following commands and paste them at')
    disp('a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  n=size(temps,2); ');
    disp('  for i=2:n-1 ')
    disp('    tempdiff=temps(i+1)-temps(i-1); ')
    disp('    timediff=times(i+1)-times(i-1); ')
    disp('    slopes(i)=tempdiff/timediff; ')
    disp('  end ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Let''s make a scatter plot of the data pairs')
    disp('(times,slopes).  We must first discard the first')
    disp('and last elements of times and slopes. ')
    disp(' ')
    disp('Copy the following commands and paste them at')
    disp('a MATLAB prompt, then execute them.')
    disp(' ')
    disp(' figure(2) ')
    disp(' s_times=times(2:n-1); ')
    disp(' s_slopes=slopes(2:n-1); ')
    disp(' plot(s_times,s_slopes,''ro'') ')
    disp(' xlabel(''time (seconds)'')  ')
    disp(' ylabel(''slope (F degree per second)'')  ')
    disp(' title(''Slope of Temperature Curve vs. Time'') ')
    disp(' ')
    disp('---------------------------------------------')
    disp('Answer the question in step 6.  Use MATLAB')
    disp('comments in your diary file to do so.')
    disp(' ')
    disp(' ')
    disp('---------------------------------------------')
    disp('To go on to part 3 of this module,')
    disp('type: ozone3.')
    disp(' ')

     