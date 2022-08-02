%  spring3.m
% Matlab file for Part 3 of the Spring Motion module
global K m y0

disp('********************************************')
disp('Part 3:  Critical Damping ')
disp('********************************************')
disp(' ')    

    format short
   
    disp('Here are the values of the spring constant K,')
    disp('the mass m, and the initial position y0 of the')
    disp('mass.  Make sure they are correctly entered.')
    disp('If not, enter the correct values. ')
    disp(' ')
    K, m, y0
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('-------------------------------------------------')
    disp('Step 1:')
    disp('Replace the default value of c below by the value')
    disp('you found above in Part 2, step 8. ')
    disp(' ')
    disp('Enter:')
    disp(' ')
    disp(' c = 300 ')
    disp(' ')
    disp('---------------------------------------------------')
    disp(' The solution to the differential equation for ')
    disp(' damped spring motion is provided with this module')
    disp(' as the function ''''dampsol(t,c)''''. ')
    disp(' ')
    disp(' Enter the commands below to plot the solution ')
    disp(' for your value of c. ')
    disp(' ') 
    disp(' t=0:0.05:3; ')
    disp(' y=dampsol(t,c); ')
    disp(' clf   % clears figure ')
    disp(' plot(t,y,''r'') ')
    disp(' title(''Damped Spring-Mass System'') ')
    disp(' grid on ')
    disp(' ')
    disp('---------------------------------------------------')
    disp('Increase c in steps of approximately 500 and replot')
    disp('each time, ')
    disp(' ')
    disp('Record your observations in your diary file as')
    disp('MATLAB comments. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('Step 2:')
    disp('Answer the question about the signifance of ')
    disp('the value c=sqrt(4*K*m).')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('Step 3 ')
    disp('Calculate the value c=sqrt(4*K*m). ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('Steps 4 thru 6')
    disp('Give your answers and explanations as MATLAB ')
    disp('comments in your diary file. ')
    disp(' ')
    disp(' ')
    disp('-----------------------------------------------')
    disp('After you have finished part 3, to continue on ')
    disp('to part 3 of this module, type: spring4.')
    disp(' ')