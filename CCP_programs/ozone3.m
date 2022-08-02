%  ozone3.m
% Matlab file for Part 3 of the Warming, Cooling,
% and Urban Ozone Pollution module

disp('********************************************')
disp('Part 3:  The Warming Curve')
disp('********************************************')
disp('  ')    

    format short

    disp('Here is the data for the warming phase: ')
    disp('of the experiment. ')
    times=[0,5,10,20,30,40,50,60,70];
    temps=[72.3, 87.2, 90.5, 93.1, 94.2,...
           94.7, 95.1, 95.3, 95.5];
    disp(' ')
    disp('We show a scatter plot of the data')
    disp('pairs (times,temps), and hold it.')
    figure(1)
    clf
    plot(times,temps,'bo')
    xlabel('Times (seconds)')
    ylabel('Temperatures (F degrees)')
    title('The Warming Curve')
    hold on
    disp(' ')
    disp('To continue, hit any key!')
    disp(' ')
    pause

    disp(' ')
    disp('--------------------------------------------')
    disp('The ambient temperature of the surroundings')
    disp('is now the temperature of the hand that is ')
    disp('grasping the probe.')
    disp(' ')
    disp('Enter a value for the variable ''''ambient'''' ')
    disp('as your estimate of the ambient temperature')
    disp('into MATLAB. (Be sure it is greater than the')
    disp('actual largest temperture in the data set.')
    disp(' ')
    disp('   ambient= ??')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('We change the vertical plot scale by subtracting ')
    disp('each temperature from the constant: ambient ')
    disp('that you entered and make a new plot of the ')
    disp('pairs (times,sctemps) in figure window 2. ')
    disp(' ')
    disp('Copy the following commands and paste them at')
    disp('a MATLAB prompt, then execute them.')
    disp(' ')
    disp(' sctemps=ambient-temps ')
    disp(' figure(2); clf ')
    disp(' plot(times,sctemps,''bo'') ')
    disp(' xlabel(''Times (days)'')  ')
    disp(' ylabel(''ambient-temperatures'') ')
    disp(' title(''The Scaled Warming Curve'') ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('To make a semilog plot of our data, we will')
    disp('plot the pairs (times, log(sctemps)).')
    disp(' ')
    disp('Copy the following commands and paste them at')
    disp('a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  plot(times,log(sctemps),''g+'') ')
    disp('  xlabel(''time '')  ')
    disp('  ylabel(''log( scaled temperature )'')  ')
    disp('  title(''SemiLog Plot of Scaled Temps'') ')
    disp(' ')
    disp('Answer the questions in step 3 as MATLAB')
    disp('comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------')  
    disp('Estimate the decay constant k, the negative of')
    disp('the average slope matching the linear trend of ')
    disp('points in the semilog plot, and enter your k')
    disp('value into MATLAB.  Note: k is a positive number.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Make sure your values of a, T0, and k are ')
    disp('entered into MATLAB (the value of a should ')
    disp('be your ambient temperature and T0 should be ')
    disp('the initial temperature of the probe before ')
    disp('warming begins.) ')
    disp(' ')
    a=ambient; T0=72.3;
    disp('----------------------------------------------')
    disp('Then make a plot of the model function:')
    disp('     T = a + (T0-a)*exp(-k*t). ')
    disp('(Note that t runs from 0 to 70 this time.) ')
    disp('The figure window has been set so that your')
    disp('plot will appear on top of the scatter plot ')
    disp('of the original (times,temps) data. ')
    figure(1)
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Answer the question in step 5.  Use MATLAB')
    disp('comments in your diary file to do so.')
    disp(' ')
    disp(' ')
    disp('---------------------------------------------')
    disp('To go on to part 4 of this module,')
    disp('type: ozone4.')

     