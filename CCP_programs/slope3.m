%  slope3.m
% Matlab file for Part 3 of the Slope module

disp('********************************************')
disp('Part 3:  Slope Fields for Radioactive Decay')
disp('********************************************')
disp('  ')    

    format short

    disp('The Meyer-von Schweidler data, and')
    disp('a plot of the data points.')
    disp(' ')
   
    activity=[0.2 35.0
              2.2 25.0
              4.0 22.1
              5.0 17.9
              6.0 16.8
              8.0 13.7
             11.0 12.4
             12.0 10.3
             15.0  7.5
             18.0  4.9
             26.0  4.0
             33.0  2.4
             39.0  1.4
             45.0  1.1]

    timdata=activity(:,1);
    raddata=activity(:,2);
    close
    plot(timdata,raddata,'o')
    hold

    disp('The Meyer-von Schweidler data plot')
    disp('will be held.  Below, we will fit')
    disp('a model curve to it.')
    disp(' ')
    disp('First we need model parameters to ')
    disp('attempt a fit.')
    disp(' ')
    P0=input('Enter P0, the initial population: '); 
    P0
    b=input('Enter b, the exponential base: '); 
    b
    disp('Find k such that ')
    disp('  P = P0*b^t = P0*e^(k*t).')
    disp('Enter the k value into MATLAB')
    disp(' ')
    disp('When you are ready to continue, type')
    disp('the word return and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
   
    disp('----------------------------------------------') 
    disp('Using what you have learned in parts 1 and 2,')
    disp('complete the following tasks: ')
    disp(' ')
    disp('1. Draw the slope field for this D.E.')
    disp('        dP/dt = k P ')
    disp('   using the slpfield command.  The time axis')
    disp('   should run from 0 to 50 and the population')
    disp('   axis should run from 0 to 35.')
    disp('     (You will have to modify dfun.m')
    disp('      using the correct k value.)')
    disp(' ')
    disp('2. Add to the plot the analytic solution')
    disp('   curve P(t) for initial condition P(0)=P0')
    disp(' ')

    disp('---------------------------------------------')
    disp('When your plots are done, to go on to part 4')
    disp('of this module, type: slope4')
    disp(' ')