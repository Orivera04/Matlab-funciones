%  ozone5.m
% Matlab file for Part 5 of the Warming, Cooling,
% and Urban Ozone Pollution module

disp('********************************************')
disp('Part 5:  Ozone Pollution in Atlanta')
disp('********************************************')
disp('  ')    

    format short

    disp('Here is the data for the times and ozone ')
    disp('levels: ')
    times=[0:10]
    ozone=[0.1500,0.14852,0.14708,0.14568,0.14433,...
           0.14301,0.14174,0.14050,0.13930,...
           0.13813,0.1370]
    disp(' ')
    disp('We show a scatter plot of the data')
    disp('pairs (times,ozone), and hold it.')
    figure(1)
    clf
    plot(times,ozone,'bo')
    axis([0 10 0.12 0.15])
    xlabel('Times (years)')
    ylabel('Ozone level')
    title('Atlanta Ozone Levels')
    hold on
    disp(' ')
    disp('-------------------------------------------')
    disp('Answer the question in step 1 as MATLAB')
    disp('comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('Entering the following commands will compute')
    disp('symmetric difference quotients to approximate')
    disp('the slope of the ozone curve at various')
    disp('times.  ')
    disp(' ')
    disp('Copy the following commands and paste them at')
    disp('a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  n=size(ozone,2); ');
    disp('  for i=2:n-1 ')
    disp('    ozdiff=ozone(i+1)-ozone(i-1); ')
    disp('    timediff=times(i+1)-times(i-1); ')
    disp('    slopes(i)=ozdiff/timediff; ')
    disp('  end ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('Let''s plot slopes versus ozone levels, i.e.,') 
    disp('plot the pairs (ozone,slopes), in figure 2.')
    disp('We must first discard the first and last')
    disp('elements of ozone and slopes.')
    disp(' ')
    disp('Copy the following commands and paste them at')
    disp('a MATLAB prompt, then execute them.')
    disp(' ')
    disp(' s_ozone=ozone(2:n-1); ')
    disp(' s_slopes=slopes(2:n-1); ')
    disp(' figure(2); clf ')
    disp(' plot(s_ozone,s_slopes,''ro'') ')
    disp(' xlabel(''ozone level'')  ')
    disp(' ylabel(''slope (ozone level per year)'')  ')
    disp(' title(''Slope of Ozone Curve vs. Level'') ')
    disp(' ')
    disp('--------------------------------------------')
    disp('Answer the question in step 2.  Use MATLAB')
    disp('comments in your diary file to do so.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('The next command fits a line (polynomial of ')
    disp('degree n=1) to the (ozone,slope) data.')
    disp(' ')
    disp('Copy the following command and paste it at')
    disp('a MATLAB prompt, then execute it.')
    disp(' ')
    disp('   coefs=polyfit(s_ozone,s_slopes,1) ')
    disp(' ')
    disp('Note that the first component, coefs(1),')
    disp('is the slope of the line of best fit and the')
    disp('second component, coefs(2) is the y-intercept.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('Note that')
    disp('   dy/dt = slope = -k*y + k*b, ')
    disp(' ')
    disp('Use your values from the best fitting line to')
    disp('find values k and b and enter them into MATLAB.')
    disp('(Be careful, k must be positive.)')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('Make sure your values of the initial ozone')
    disp('level y0, as well as b and k, are entered ')
    disp('into MATLAB.')
    disp(' ')
    y0=0.15;

    disp('--------------------------------------------')
    disp('Then make a plot of the model function:')
    disp('     y = b + (y0-b)*exp(-k*t). ')
    disp('(Note that t goes from 0 to 10.) ')
    disp('The figure window has been set so that it')
    disp('will appear on top of the scatter plot of')
    disp('the original (times,temps) data. ')
    figure(1)
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('Do the calculations and answer the questions')
    disp('in steps 5 and 6.  Use MATLAB comments in')
    disp('your diary file to do so.')
    disp(' ')
    disp('--------------------------------------------')
    disp('To go on to Part 6 of this module,')
    disp('type: ozone6.')
    disp(' ')

     