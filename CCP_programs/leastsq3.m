%  leastsq3.m
% Matlab file for Part 3 of the Least Squares module

disp('*********************************************')
disp('Part 3:  The normal equations ')
disp('*********************************************')
disp(' ')    

    format short

    disp('----------------------------------------------------')
    disp('Step 1:')
    disp('We construct the matrix X from Part 2 again and')
    disp('solve the normal equations. ')
    disp(' ')
    disp('Enter ')
    disp(' ')
    disp(' X = [one, x] ')
    disp(' v = (X''*X)\(X''*y); ')
    disp(' b = v(1) ')    
    disp(' m = v(2) ')
    disp(' ')
    disp('----------------------------------------------------')
    disp('Explain how the Gram-Schmidt process generated the')
    disp('matrix U.  Use MATLAB comments. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------')
    disp('Step 2: ')
    disp('Calculate p by the alternative method using m and b ')
    disp('and confirm it gives the same result found in Part 2. ')
    disp(' ')
    disp('Discuss using MATLAB comments. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------')
    disp('Step 2: ')
    disp('Do necessary computations and answer the question')
    disp('and interpret your answer using MATLAB comments. ')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('To go on to part 4 of this module, ')
    disp('type: leastsq4')
    disp(' ')