%  rain2.m
% Matlab file for Part 2 of the Raindrops module

disp('********************************************')
disp('Part 2:  Falling Bodies with Air Resistance')
disp('********************************************')
disp('  ')    

    format short

    c=52.6
    disp('Write down (as a MATLAB comment in your')
    disp('diary file) the answer to the question:')
    disp('  Why must the units for c be sec^-1? ') 
    disp(' ')
    disp('---------------------------------------------')
    disp('We want to draw the slope field for the')
    disp('differential equation: ')
    disp(' ')
    disp(' dv/dt = g - c v')
    disp('       = 32.2 - 52.6 v')
    disp(' ')
    disp('Time t will run from 0 to 0.1 and ')
    disp('velocity v will run from 0 to 1.')
    disp(' ')
    disp('Remember you have to change the ')
    disp('dfun.m file before you can use the')
    disp('   slpfield(0,0.1,0,1)     command.')
    disp('To hold the plot, type: hold on.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('---------------------------------------------')
    disp('Write down (as a MATLAB comment in your')
    disp('diary file): ')
    disp(' What is your guess for a solution ')
    disp(' (or the actual solution if you know it)')
    disp(' for the velocity of the raindrop')
    disp(' as a function of time?')
    disp(' ')

    disp('---------------------------------------------')
    disp('After making your guess, to go on to ')
    disp('Part 3 of this module, type: rain3')
    disp(' ')

