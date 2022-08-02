%  orthog3.m
% Matlab file for Part 3 of the Orthogonality module

disp('*********************************************')
disp('Part 3:  Orthonormal bases')
disp('*********************************************')
disp('  ')    

    format short
    
    disp('Step 1:')
    disp('The first column of U will just be')
    disp('   U1 = A1/norm(A1) ')
    disp(' ')
    disp('You can the define the matrix U by assembling')
    disp('the columns: ')
    disp('   U = [U1. U2, U3, U4] ')
    disp(' ')
    disp('----------------------------------------------')
    disp('Calculate the matrix U. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------')
    disp('Steps 2 thru 4: ')
    disp('Do the prescribed calculations, compare, and')
    disp('explain your results using MATLAB comments. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 5: ')
    disp('Enter the command to generate a new vector y  ')
    disp('in 8-space.  Then find the vector in W closest ')
    disp('to y and find the distance from y to W. ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp(' y = floor( 100*(2*rand(8,1)-1) ) ')
    disp(' ')
    disp(' ')
    disp('When you have finished your calculations, in')
    disp('order to go on to part 4 of this module, ')
    disp('type: orthog4')
    disp(' ')