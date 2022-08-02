%  time3.m
% Matlab file for Part 3 of the Time and Temperature
% module

disp('********************************************')
disp('Part 3:  Fitting to Temperature Data')
disp('********************************************')
disp('  ')    

    format short

    disp('Step 1: ')
    disp('Below is a vector of data which gives ')
    disp('the Kalamazoo temperature data for each')
    disp('month.')
    disp(' ')
    Kzoo=[24,27,36,49,60,69,73,72,65,54,40,29]
    disp(' ')
    disp('We show a scatter plot of the Kalamazoo')
    disp('data pairs (month,Kzoo), and hold it.')
    clf
    plot(month,Kzoo,'bo')
    disp(' ')
    hold
    disp(' ')
    disp('To continue, hit any key!')
    disp(' ')
    pause

    disp(' ')
    disp('--------------------------------------------')
    disp('Step 2:')
    disp('Fit the scatter plot with a sinusoidal')
    disp('function of the form:')
    disp('      T = A + B*sin( C*(t-t0) ).  ')
    disp(' ')
    disp('--------------------------------------------')
    disp('Give your best estimate of the coefficients ')
    disp('A, B, C, t0.  Iterate by changing the values')
    disp('of the coefficients to achieve the best fit.')
    disp('Plot your best fitting function on top of the')
    disp('scatter plot. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp(' ')
    disp('Step 3:')
    disp('Below is a vector of data which gives ')
    disp('the Helsinki average monthly temperature data')
    disp('for each month in degrees centigrade.')
    disp(' ')
    Helsinki=[-6,-6,-3.5,4,7,14,16.5,15,10.5,6,0.5,-2.5]
    disp(' ')
    disp('We show a scatter plot of the Helsinki')
    disp('data pairs (month,Helsinki), and hold it.')
    clf
    plot(month,Helsinki,'bo')
    disp(' ')
    hold
    disp(' ')
    disp('To continue, hit any key!')
    disp(' ')
    pause

    disp(' ')
    disp('Step 3 (cont.): ')
    disp('----------------------------------------------')
    disp('Fit the Helsinki scatter plot with a sinusoidal')
    disp('function of the form:')
    disp('      T = A + B*sin( C*(t-t0) ).  ')
    disp(' ')
    disp('--------------------------------------------')
    disp('Give your best estimate of the coefficients ')
    disp('A, B, C, t0.  Iterate by changing the values')
    disp('of the coefficients to achieve the best fit.')
    disp('Plot your best fitting function on top of the')
    disp('scatter plot. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 4: ')
    disp('Provide computations and answers in your diary')
    disp('file for step 4.')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('To go on to part 4 of this module, ')
    disp('type: time4.')
    disp(' ') 