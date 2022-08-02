%  leslie2.m
% Matlab file for Part 2 of the Leslie Growth Models
% module

disp('*********************************************')
disp('Part 2:  Age-distributed growth ')
disp('*********************************************')
disp('  ')    

    format short

    disp('The single positive eigenvalue of L is')
    lam1=1.17557142326043

    disp('------------------------------------------------') 
    disp('Step 1:')
    disp('The steps below start with an arbitrary initial')
    disp('vector x0, then compute xk = (L^k)*x0. for k=10.')
    disp('Then we check to see if xk is an eigenvector. ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  k=10 ')
    disp(' ')
    disp('  x0=[1,1,1,1,1,1,1,1,1,1,1,1]; ')
    disp('  xk=(L^k)*x0 ')
    disp('  L*xk ')
    disp('  lam1*xk')
    disp(' ')
    disp('----------------------------------------------')
    disp('How close is xk to an eigenvector for lam1?')
    disp('Explain using MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 2: ')
    disp('Increase k in the step above and recompute until ')
    disp('xk is essentially an eigenvector to the precision')
    disp('shown.  You can also change x0 to see if the ')
    disp('procedure still yields an eigenvector. ')
    disp(' ')
    disp('Modify your eigenvector by dividing it by the sum')
    disp('of its components.  This is a state vector. ')
    disp(' ')
    disp('Interpret results and answer the remaining questions.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('To go on to part 3 of this module, ')
    disp('type: leslie3')
    disp(' ')