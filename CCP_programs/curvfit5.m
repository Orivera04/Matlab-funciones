%  curvfit5.m
% Matlab file for Part 5 of the Curve Fitting module

disp('*********************************************')
disp('Part 5:  Nonlinear Curve Fitting ')
disp('*********************************************')
disp('  ')

    format short

    disp('Step 1: ') 
    disp('Enter the data the Small Data Set below.')
    disp('Solve for a and b so that the power function')
    disp('y = a*t^b goes through the first and last points ')
    disp('(1, 2.5) and (4, 50.0) of the data. ')
    disp(' ')
    disp('  t = (1:4)'' ')
    disp('  y = [2.5, 8.0, 19.9, 50.0]'' ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')

    disp('-------------------------------------------------')
    disp('Step 2A: ') 
    disp('Enter your initial quess a0 and b0 from step 1')
    disp('as well as the following commands to define the')
    disp('model function and its partial derivatives.')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  a0 = ?')
    disp('  b0 = ?')
    disp(' ')
    disp('  fun = inline(''a*t.^b'') ')
    disp('  funa = inline(''t.^b'') ')
    disp('  funb = inline(''a*t.^b.*log(t)'') ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('-------------------------------------------------')
    disp('Step 2B: ') 
    disp('Enter the commands below to use your initial guess')
    disp('to compute the data vectors:')
    disp(' ')
    disp(' a = a0  ')
    disp(' b = b0  ')
    disp(' ')
    disp(' ystar = y - fun(a,b,t) ')
    disp(' fa = funa(b,t); ')
    disp(' fb = funb(a,b,t); ')
    disp(' X = [fa, fb] ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------------')
    disp('Step 2C and 3:')
    disp('Solve the normal equations for da and db and update')
    disp('the values of a and b. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------------')
    disp('Step 4:')
    disp('Use your updated values of a and b as your new guess')
    disp('and return to step 2B to recompute the data vectors')
    disp('and then resolve the normal equations for da and db')
    disp('and update a and b as you did in steps 2C and 3.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------------')
    disp('Step 5:')
    disp('Repeat steps 2B thru 3 for the updated a and b again.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')

    disp('----------------------------------------------------')
    disp('Step 6:')
    disp('The following ''while'' loop carries out the updating ')
    disp('steps automatically until the values of parameters  ')
    disp('a and b converge.  Make sure your initial values ')
    disp('a0 and b0 are entered before you start the loop. ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  % Initialize: ')
    disp('  a=a0  ')
    disp('  b=b0  ')
    disp('  iter = 0;')
    disp('  dx=1.0e6; ')
    disp('  form0 = ''iter = %d   a = %d   b = %d\n''; ')
    disp(' ')
    disp('  % Iterate until changes to parameters are tiny:' )
    disp('  while (norm(dx)>1.0e-4) & (iter<20) ')
    disp('     ystar = y - fun(a,b,t); ')
    disp('     fa = funa(b,t); ')
    disp('     fb = funb(a,b,t); ')
    disp('     X = [fa, fb]; ')
    disp('     dx = (X''*X)\(X''*ystar); ')
    disp('     iter = iter + 1; ')
    disp('     a=a+dx(1); ')
    disp('     b=b+dx(2); ')
    disp('     fprintf(1,form0,[iter,a,b]) ')
    disp('  end           ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------------')
    disp('Step 6 (cont.) ')
    disp('Compute the residuals and the sum of squares of')
    disp('residuals for your best-fitting power function.')
    disp('Comment on the fit using MATLAB comments. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------------')
    disp('Logistic fit to population data ')
    disp(' ')
    disp('Enter the U.S. population data: ')
    disp(' ')
    disp('  times = 1900:10:1990; ')
    disp('  y = [75.996,91.972,105.711,122.775,131.669,...')
    disp('       150.697,179.323,203.185,226.546,248.710]''; ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------------')
    disp('Step 7 ')
    disp('The following commands find the partial derivatives ')
    disp('of the logisitic model and define the partials as ')
    disp('inline functions. ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  syms t P0 K r ')
    disp('  f = K*P0/( P0 + (K-P0)*exp(-r*t) ) ')
    disp('  fun = fcnchk(char(f),''vectorized''); ')
    disp('  fP0 = simple( diff(f,P0) ) ')
    disp('  funP0 = fcnchk(char(fP0),''vectorized''); ')
    disp('  fK = simple( diff(f,K) ) ')
    disp('  funK = fcnchk(char(fK),''vectorized''); ')
    disp('  fr = simple( diff(f,r) ) ')
    disp('  funr = fcnchk(char(fr),''vectorized''); ')
    disp('  t = (times - 1900)'';  % Override sym t ')
    disp('  clear fP0 fK fr ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------------')
    disp('Step 8: ')
    disp('The following commands enter the initial guesses for ')
    disp('the parameters and form the data vectors and least ')
    disp('squares matrix X ')
    disp(' ')
    disp(' P01 = 78;  ')
    disp(' K0 = 700;  ')
    disp(' r0 = 0.0168;  ')
    disp(' ')
    disp(' P0 = P01')
    disp(' K = K0')
    disp(' r = r0')
    disp(' ')
    disp(' ystar = y - fun(K,P0,r,t) ')
    disp(' fP0 = funP0(K,P0,r,t); ')
    disp(' fK = funK(K,P0,r,t); ')
    disp(' fr = funr(K,P0,r,t); ')
    disp(' X = [fP0, fK, fr] ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------------')
    disp('Step 8 (cont.) ')
    disp('Solve the normal equations for dP0, dK, and dr ')
    disp('and use these values to update P0, K, and r. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------------')
    disp('Step 9:')
    disp('The following ''while'' loop carries out the updating ')
    disp('steps automatically until the values of parameters  ')
    disp('P0, K, r converge.  Make sure your initial values ')
    disp('of the parameters are entered before you start the loop. ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  % Initialize: ')
    disp('  P0 = P01  ')
    disp('  K = K0  ')
    disp('  r = r0  ')
    disp('  iter = 0;')
    disp('  dx=1.0e6; ')
    disp('  form1 = ''%d   P0 = %d   K = %d  r = %d\n''; ')
    disp(' ')
    disp('  % Iterate until changes to parameters are tiny:' )
    disp('  while (norm(dx)>1.0e-4) & (iter<20) ')
    disp('     ystar = y - fun(K,P0,r,t); ')
    disp('     fP0 = funP0(K,P0,r,t); ')
    disp('     fK = funK(K,P0,r,t); ')
    disp('     fr = funr(K,P0,r,t); ')
    disp('     X = [fP0, fK, fr]; ')
    disp('     dx = (X''*X)\(X''*ystar); ')
    disp('     iter = iter + 1; ')
    disp('     P0=P0+dx(1); ')
    disp('     K=K+dx(2); ')
    disp('     r=r+dx(3); ')
    disp('     fprintf(1,form1,[iter,P0,K,r]) ')
    disp('  end           ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------------')
    disp('Steps 10 and 11:')
    disp('The following commands plot the logistic fit and the ')
    disp('residuals. ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  figure(1); clf ')
    disp('  plot(times,y,''bo''); hold on ')
    disp('  taxis = 1890:2:2000; ')
    disp('  tvals = taxis - 1900; ')
    disp('  ypred = fun(K,P0,r,tvals); ')
    disp('  plot(taxis,ypred,''r'') ')
    disp('  axis([1890,2000,0,300]); ')
    disp('  title(''Logistic fit to U.S. population data'') ')
    disp(' ')
    disp('  p = fun(K,P0,r,t); ')
    disp('  resid = y - p ')
    disp('  figure(2); clf ')
    disp('  plot(times, resid, ''bo''); hold on ')
    disp('  plot(taxis, zeros(size(taxis,2),1), ''k'') ')
    disp('  axis([1890,2000, -6,6]); ')
    disp('  title(''Residual plot for logistic fit'') ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------------')
    disp('Steps 10 and 11 (cont.):')
    disp('Calculute the sum of squares of residuals S for ')
    disp('the logistic fit.  Compare the fit of the logistic')
    disp('model to the quadratic and exponential fits.')
    disp('Discuss how the residual plots compare.')
    disp('Use MATLAB comments for your discussion.')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('To go on to part 6 of this module, ')
    disp('type: curvfit6')
    disp(' ')
