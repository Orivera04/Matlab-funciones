%  time2.m
% Matlab file for Part 2 of the Time and Temperature
% module

disp('********************************************')
disp('Part 2:  Fitting to Sunlight Data')
disp('********************************************')
disp('  ')    

    format short

    disp('Below are three vectors of data.  The first')
    disp('gives numbers for the months of the year.')
    disp('The second gives the time of sunrise for')
    disp('the first day of each month.  The third')
    disp('likewise gives sunset times for each month.')
    month=[1,2,3,4,5,6,7,8,9,10,11,12]
    sunrise=[7.43,7.27,6.77,6.03,5.38,5.00,5.05,...
             5.38,5.78,6.18,6.63,7.13]
    sunset=[17.22,17.72,18.18,18.63,19.05,19.45,...
            19.60,19.33,18.72,17.98,17.33,17.03]
    disp(' ')
    disp('To continue, hit any key!')
    disp(' ')
    pause

    disp(' ')
    disp('--------------------------------------------')
    disp('Step 1:')
    disp('Use the sunrise and sunset data to calculate')
    disp('a vector named daylight which gives average')
    disp('hours of daylight for each month.')
    disp(' ')
    disp('Make a scatter plot of the data pairs')
    disp('(month,daylight) by using the commands:')
    disp(' ')
    disp('     plot(month,daylight,''bo'')    ')
    disp('     xlabel(''Month number'')       ')
    disp('     ylabel(''Hours of Daylight'')  ')
    disp('     title(''Daylight Hours Each Month'') ')
    disp('     hold on  ')
    disp(' ')
    disp('(The hold on command just saves the plot so ')
    disp(' that you can add other data to it.) ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 2:')
    disp('Enter your best estimates of the parameters')
    disp('A, B, C, and t0 in the sinusoidal function:')
    disp('     y = A + B*sin( C*(t-t0) ) ')
    disp('that you are trying to fit to the data. ')
    disp(' ')
    disp('----------------------------------------------') 
    disp('After you have entered the values of the')
    disp('parameters, then copy, paste, and execute the')
    disp('following commands to graph that sinusoidal ')
    disp('function on top of your (month,daylight) data.')
    disp(' ')
    disp('  t=1:0.25:12; ')
    disp('  y = A + B*sin( C*(t-t0) ); ')
    disp('  plot(t,y,''r'')   ')
    disp(' ')
    disp('----------------------------------------------')  
    disp('You should iteratively change the values of the')
    disp('parameters A, B, C, t0 and then re-plot the')
    disp('trig function to try to achieve a good fit.')
    disp(' ')
    disp('Comment on the goodness of fit using MATLAB')
    disp('comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 3:')
    disp('Make scatter plots of the (month,sunrise)')
    disp('data and also the (month,sunset) data.')
    disp(' ')
    disp('----------------------------------------------')
    disp('Choose one of the scatter plots for fitting')
    disp('with a sinusoidal function of the form:')
    disp('      y = A + B*sin( C*(t-t0) ).  ')
    disp(' ')
    disp('Give your best estimate of the coefficients ')
    disp('A, B, C, t0 after iteratively changing them')
    disp('to achieve the best fit.  Plot your best-')
    disp('fitting sinusoid on top of the scatter plot.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 3 (cont.):')
    disp('Provide answers to the rest of the questions ')
    disp('in step 3 as MATLAB comments in your diary')
    disp('file.')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------') 
    disp('When the questions are answered, to go on to')
    disp('part 3 of this module, type: time3.')
    disp(' ')