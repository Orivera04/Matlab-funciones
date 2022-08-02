%  eigval3.m
% Matlab file for Part 3 of the Eigenvalues and 
% Eigenvectors module

disp('*********************************************')
disp('Part 3:  Eigenvalues and Determinants')
disp('*********************************************')
disp('  ')    

    format short
    
    A = [2,1,1; 2,3,4; -1,-1,-2];
    B = [2,-1,1; 0,3,-1; 2,1,3];
    C = [2,1,1; 2,3,2; 3,3,4];
    I = eye(3,3);

    disp('Step 1: ')
    disp('The following commands compute the eigenvalues')
    disp('of matrix A to compare to A''s determinant.')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  eig(A) ')
    disp('  det(A) ')
    disp(' ')
    disp('------------------------------------------------')
    disp('Also compare the eigenvalues to the determinant ')
    disp('of matrix B.  Likewise for matrix C.')
    disp('  (Don''t be concerned with the ''''0.0000i''''. ')
    disp('   The eigenvalues are really real, but roundoff')
    disp('   produces a very tiny imaginary part.) ')
    disp(' ')
    disp('Formulate a rule relating the eigenvalues and the ')
    disp('determinant of a matix.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 2')
    disp('Entering the following commands will generate')
    disp('a random symmetric 3 by 3 matrix R and compute')
    disp('its eigenvalues and determinant. ')
    disp('Enter: ')
    disp(' ')
    disp('  R = floor( 50*(2*rand(3)-1) ); R = R + R''  ')
    disp('  e = eig(R) ')
    disp('  det(R) ')
    disp(' ')
    disp('------------------------------------------------')
    disp('Check the rule you have formulated by seeing')
    disp('if it holds for various random matrices.')
    disp(' ')
    disp('Describe your results by using MATLAB comments in')
    disp('your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------')
    disp('Step 3: ')
    disp('Give the algebraic justification for your rule.')
    disp('Use MATLAB comments in your diary file.') 
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('To go on to part 4 of this module, ')
    disp('type: eigval4')
    disp(' ')