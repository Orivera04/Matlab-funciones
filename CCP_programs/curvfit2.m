%  curvfit2.m
% Matlab file for Part 2 of the Curve Fitting module

disp('*********************************************')
disp('Part 2:  Linear Least Squares')
disp('*********************************************')
disp('  ')

    format short

    disp('Step 1: ') 
    disp('Enter the data vectors: ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  t = (-2.0: 0.5: 3.0)''; ')
    disp('  y = [-6.32,-3.23,1.62,3.13,1.74,-0.75,... ')
    disp('       -1.41,1.78,8.88,9.98,7.10]''; ')
    disp('  one = ones(11,1); ')
    disp('  s1 = sin(t); ')
    disp('  c1 = cos(t); ')
    disp('  s2 = sin(2*t); ')
    disp('  c2 = cos(2*t); ')
    disp(' ') 
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')

    disp('----------------------------------------------------')
    disp('Step 1 (cont.): ')
    disp('Enter the command to form the matrix X whose ')
    disp('columns are one, s1, c1, s2, c2. ')
    disp(' ')
    disp('Then solve the normal equations for the coefficients ')
    disp('a0, a1, b1, a2, b2. ') 
    disp(' ')
    disp('Enter ')
    disp(' ')
    disp(' X = [one, s1, c1, s2, c2] ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------------')
    disp('Step 2: ')
    disp('Assuming the coefficients a0, a1, b1, a2, and b2 ')
    disp('are entered into MATLAB, the following commands ')
    disp('allow you to plot the least squares trig polynomial ')
    disp('together with the Signal Strength data set. ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  clf ')
    disp('  plot(t,y,''bo''); hold on ')
    disp('  t1 = -3.0: 0.1: 4.0; ')
    disp('  ypred=a0 + a1*sin(t1) + b1*cos(t1) + ... ')
    disp('             a2*sin(2*t1) + b2*cos(2*t1); ')
    disp('  plot(t1,ypred,''r'') ')
    disp('  axis([-3,4, -8,12]); ')
    disp(' ')
    disp('----------------------------------------------')
    disp('Use MATLAB comments in your diary file to')
    disp('comment on the goodness of fit. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('-----------------------------------------------------')
    disp('Step 3:')
    disp('The following commands compute and plot the residuals.  ')
    disp(' ')
    disp('  p= a0 + a1*s1 + b1*c1 + a2*s2 + b2*c2 ')
    disp('  resid = y - p ')
    disp('  figure(2); clf ')
    disp('  plot(t, resid, ''bo''); hold on ')
    disp('  plot(t1, zeros(size(t1,1),1), ''k'') ')
    disp('  axis([-3,4, -1,1]); ')
    disp(' ')
    disp('-------------------------------------------------')
    disp('Use MATLAB comments in your diary file to comment')
    disp('on what you learn from the residual plot. ')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('To go on to part 3 of this module, ')
    disp('type: curvfit3')
    disp(' ')
